TOPLEVEL_LANG ?= vhdl
SIM ?= ghdl
WAVES ?= 0
GUI ?= 0


COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps


PWD=$(shell pwd)


DUT           = popcount
TOPLEVEL      = $(DUT)
MODULE        = test_$(DUT)
VHDL_SOURCES += $(PWD)/../../rtl/bnn_adder.vhdl
VHDL_SOURCES += $(PWD)/../../rtl/bnn_dff.vhdl
VHDL_SOURCES += $(PWD)/../../rtl/bnn_substr.vhdl
VHDL_SOURCES += $(PWD)/../../rtl/$(DUT).vhdl


ifeq ($(SIM), ghdl)
# 	SIM_ARGS += -v
	COMPILE_ARGS += -v
# 	ifeq ($(WAVES), 1)
# 		SIM_ARGS += --vcd=$(TOPLEVEL).vcd
# 	endif
endif


include $(shell cocotb-config --makefiles)/Makefile.sim


clean::
	-rm -rf callgraph.svg
	-rm -rf __pycache__
	-rm -rf work
	-rm -rf modelsim.ini
	-rm -rf results.xml
	-rm -rf *.vstf
	-rm -rf *.wlf
	-rm -rf *.vcd
	-rm -rf transcript
	-rm -rf iverilog_dump.v