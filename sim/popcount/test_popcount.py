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

        cocotb.fork(Clock(dut.clk, 2, units="ns").start())

    async def reset(self):
        self.dut.rst.setimmediatevalue(1)
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)
        self.dut.rst.value = 0
        await RisingEdge(self.dut.clk)
        await RisingEdge(self.dut.clk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def pcnt_2p_n(sample):
    bit_cnt = 0
    for i in len(sample):
        if ((sample >> i) & 0x1):
            bit_cnt += 1

    double_p = bit_cnt << 1
    double_pn = double_p - len(sample)
    return double_pn


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_test_tx(dut, payload_lengths=None, payload_data=None):
    tb = TB(dut)
    await tb.reset()

    dut.i_val.value = 0
    dut.stream_i.value = 0

    for test_data in [payload_data(x) for x in payload_lengths()]:
        
        tx_data = list()
        for word in test_data:
            await RisingEdge(dut.clk)
            dut.i_val.value = 1
            dut.stream_i.value = word
            tx_data.append(word)
        await RisingEdge(dut.clk)
        dut.i_val.value = 0

        rx_data = list()
        while len(rx_data) < int(len(tx_data)):
            await RisingEdge(dut.clk)
            if (dut.o_val.value):
                rx_data.append(dut.stream_o.value)

        tb.log.info("TX data: %s", tx_data)
        tb.log.info("RX data: %s", rx_data)

        # assert ctx_data == rx_data

        await Timer(1, 'us')

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs31(state=0x7fffffff):
    while True:
        for i in range(8):
            if bool(state & 0x08000000) ^ bool(state & 0x40000000):
                state = ((state & 0x3fffffff) << 1) | 1
            else:
                state = (state & 0x3fffffff) << 1
        yield state & 0xff


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs_payload(length):
    gen = prbs31()
    return bytearray([next(gen) for x in range(length)])


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
    # for test in [run_test_rx, run_test_rx]:
    #     factory = TestFactory(test)
    #     factory.add_option("payload_lengths", [size_list])
    #     factory.add_option("payload_data", [incrementing_payload, prbs_payload])
    #     factory.generate_tests()
    factory = TestFactory(run_test_tx)
    factory.add_option("payload_lengths", [size_list])
    factory.add_option("payload_data", [incrementing_payload])
    factory.generate_tests()
