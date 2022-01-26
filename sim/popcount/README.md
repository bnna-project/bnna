# Testbench for PE module

The idea is merge BNN PE operation in one unit with pipeline.
At the moment the module implements simple function:

`2*popcount(x) - size(x)`

The testbench is using System Verilog language features. Means there are some requirements to simulator.

## Dependencies

- ModelSim

> Feel free to use any simulator with SV support

## Usage

From ModelSim command line:

cd <repo>/sim/popcount
do sim.do sim
do wave.do
do sim.do; run -all

Number of words for test popcount_tb.sv -> N_TEST_WORDS;
