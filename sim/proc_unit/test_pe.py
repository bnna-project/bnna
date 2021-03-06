#!/usr/bin/env python

import itertools
import logging
import os
import random

import cocotb_test.simulator

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.regression import TestFactory


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
class TB(object):
    def __init__(self, dut):
        self.dut = dut

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        cocotb.fork(Clock(dut.clk, 1, units="ns").start())

    async def reset(self):
        self.dut.reset.setimmediatevalue(1)
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.reset.value = 0
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def xnor_popcount(data, weights):
    # xnor
    xnor = ~(data ^ weights)
    xnor_str = format(xnor & 0xffffffffffffffff, '064b')

    # popcount
    bit_cnt = 0
    for i in range(len(xnor_str)):
        if(xnor_str[i] == "1"):
            bit_cnt += 1
    #2P-N
    double_p = bit_cnt << 1
    double_pn = double_p - len(xnor_str)

    return double_pn


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def get_data(dut, size, rx_data):
    while len(rx_data) < size:
        await RisingEdge(dut.clk)
        if (dut.o_val_pe.value):
            rx_data.append(dut.result.value.integer)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_data(dut, test_data, tx_data):
    acc = 0
    result = 0
    threshold = 0
    for word in test_data:
        dut.i_val_outside.value = 1
        dut.data.value = word
        dut.weights.value = word-1
        dut.threshold.value = 0

        acc += xnor_popcount(word, word-1)
        if(acc >= threshold):
            result = 1
        else:
            result = 0
        tx_data.append(result)

        await RisingEdge(dut.clk)

    dut.i_val_outside.value = 0


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_test(dut, payload_lengths=None, payload_data=None):
    tb = TB(dut)

    dut.i_val_outside.value = 0
    dut.data.value = 0
    dut.weights.value = 0
    dut.threshold.value = 0

    for test_data in [payload_data(x) for x in payload_lengths()]:
        await tb.reset()

        tx_data = list()
        rx_data = list()

        await cocotb.start(run_data(dut, test_data, tx_data))
        await cocotb.start(get_data(dut, len(test_data), rx_data))

        await Timer(2, 'us')

        tb.log.info("TX data: %s", tx_data)
        tb.log.info("RX data: %s", rx_data)

        assert tx_data == rx_data

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs63(state=0x7fffffffffffffff):
    while True:
        for i in range(64):
            if bool(state & 0x08000000000000) ^ bool(state & 0x4000000000000000):
                state = ((state & 0x3fffffffffffffff) << 1) | 1
            else:
                state = (state & 0x3fffffffffffffff) << 1
        yield state & 0xffffffffffffffff


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs_payload(length):
    gen = prbs63()
    return [next(gen) for x in range(length)]


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def incrementing_payload(length):
    return bytearray(itertools.islice(itertools.cycle(range(256)), length))


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def size_list():
    return list(range(1, 16)) + [32, 128, 1024]


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
# cocotb-test
if cocotb.SIM_NAME:
    factory = TestFactory(run_test)
    factory.add_option("payload_lengths", [size_list])
    factory.add_option("payload_data", [incrementing_payload, prbs_payload])
    factory.generate_tests()
