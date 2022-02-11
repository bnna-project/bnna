# Testbench for tricky POPCOUNT module

The idea is merge BNN 2P-N operation in one unit with pipeline.

At the moment the module implements simple function: `2*popcount(x) - size(x)`

The testbench is written with cocotb.

## Dependencies

- Python 3.6+
- GHDL 0.37
- cocotb 1.6.1
- VHDL 2008

> Feel free to use any simulator with VHDL and cocotb support.

## Usage

### Linux

From CLI:

    $ cd <this folder>
    $ make clean
    $ make WAVES=1
    $ gtkwave ./popcount.vcd
    
### Windows

From MSYS2 shell:

    $ cd <this folder>
    $ make clean
    $ make WAVES=1
    $ gtkwave .\popcount.vcd
