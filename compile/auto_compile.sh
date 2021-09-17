#!/bin/bash

ghdl -s ../PUmodul/xnor/parameters.vhdl
ghdl -a ../PUmodul/xnor/parameters.vhdl

ghdl -s ../PUmodul/xnor/xnor_2.vhdl
ghdl -a ../PUmodul/xnor/xnor_2.vhdl

ghdl -s ../PUmodul/register/cache.vhdl
ghdl -a ../PUmodul/register/cache.vhdl

ghdl -s ../PUmodul/pop_count/pop_count.vhdl
ghdl -a ../PUmodul/pop_count/pop_count.vhdl

ghdl -s ../PUmodul/comparator/comparator.vhdl
ghdl -a ../PUmodul/comparator/comparator.vhdl

ghdl -s ../processing_unit/processing_unit.vhdl
ghdl -a ../processing_unit/processing_unit.vhdl

ghdl -s ../Outputbuffer/out.vhdl
ghdl -a ../Outputbuffer/out.vhdl

ghdl -s ../input_buffer/buffer_bnn.vhdl
ghdl -a ../input_buffer/buffer_bnn.vhdl

ghdl -s ../Controller/InputComplete/input.vhdl
ghdl -a ../Controller/InputComplete/input.vhdl

ghdl -s ../Controller/FIFO/fifo.vhdl
ghdl -a ../Controller/FIFO/fifo.vhdl

ghdl -s ../Controller/CaculatorModul/cal.vhdl
ghdl -a ../Controller/CaculatorModul/cal.vhdl

ghdl -s ../Controller/Controller/Controller.vhdl
ghdl -a ../Controller/Controller/Controller.vhdl

ghdl -s ../BNNA/bnn.vhdl 
ghdl -a ../BNNA/bnn.vhdl
