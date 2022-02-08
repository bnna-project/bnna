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
        tb.log.info("Reset")
        # self.dut.rst.setimmediatevalue(0)
        # await RisingEdge(self.dut.clk)
        # await RisingEdge(self.dut.clk)
        # self.dut.rst.value = 1
        # await RisingEdge(self.dut.clk)
        # await RisingEdge(self.dut.clk)
        # self.dut.rst.value = 0
        # await RisingEdge(self.dut.clk)
        # await RisingEdge(self.dut.clk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_test_tx(dut, payload_lengths=None, payload_data=None):
    tb = TB(dut)
    # await tb.reset()

    # for test_data in [payload_data(x) for x in payload_lengths()]:

    #     # for word in test_data:
    #     #     await RisingEdge(dut.clk)
    #     #     dut.stream_i = word

    #     # encoded_data = cobs_encode(test_data)+b'\00'
    #     # await tb.axi_source.write(test_data)

    #     # rx_data = bytearray()
    #     # while len(rx_data) < int(len(encoded_data)):
    #     #     rx_data.extend(await tb.uart_sink.read())

    #     # tb.log.info("Sended data: %s", test_data)
    #     # tb.log.info("Received (encoded) data: %s", rx_data)
    #     # tb.log.info("Parsed data: %s", cobs_decode(rx_data[:-1]))

    #     # assert tb.uart_sink.empty()
    #     # assert cobs_decode(rx_data[:-1]) == test_data

    #     await Timer(1, 'us')

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
    factory = TestFactory(test)
    factory.add_option("payload_lengths", [size_list])
    factory.add_option("payload_data", [incrementing_payload])
    factory.generate_tests()
