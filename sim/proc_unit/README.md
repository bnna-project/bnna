# Testbench for Processing Element module

The idea is merge BNN processing element functions in one module with pipeline.

The module implements the functions:

```
input_data - data vector
input_weight - weight vector
input_threshold - threshold vector

acc = 0
while (!done) {
  a = xnor(input_data, input_weight)
  b = 2*popcount(a) - size(input_data)
  acc += b
  done = (acc >= input_threshold)
}
```

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

From MSYS2 (or Conda) shell:

    $ cd <this folder>
    $ make clean
    $ make WAVES=1
    $ gtkwave .\popcount.vcd
