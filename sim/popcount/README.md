# Testbench for tricky POPCOUNT module

The idea is merge BNN 2P-N operation in one unit with pipeline.

At the moment the module implements simple function: `2*popcount(x) - size(x)`

The testbench is written with cocotb.

## Dependencies

- Python 3.6+ (obviously)
- GHDL 0.37
- cocotb 1.6.1

> Feel free to use any simulator with VHDL and cocotb support. There was some issues with GHDL and Windows,
so it is better to use Linux if you suppose to use GHDL.

## Usage

### Linux

From CLI:

- `cd <this folder>`
- `make clean`
- `make WAVES=1` - if you'd like to get waveforms, else `make`
- `gtkwave ./popcount.vcd`

### Windows

From MSYS2 shell:

- `cd <this folder>`
- `make clean`
- `make WAVES=1` - if you'd like to get waveforms, else `make`
- `gtkwave .\popcount.vcd`