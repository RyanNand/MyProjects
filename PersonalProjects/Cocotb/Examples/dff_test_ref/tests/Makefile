#### Declare the HDL we used in the design
TOPLEVEL_LANG ?= verilog

#### Declare the default simulator to use
SIM ?= icarus

#### Tell cocotb where our HDL source files are depending on the language we used
ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES = $(shell pwd)/../hdl/dff.sv
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES = $(shell pwd)/dff.vhdl
endif

#### Tell Python the module that contains the test functions to perform on the DUT
MODULE = test_dff

#### Declare the top-level module (synonmous with DUT, component, and instance) in the design
TOPLEVEL = dff

#### Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
