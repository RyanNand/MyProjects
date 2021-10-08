#### Declare the HDL used in the design
TOPLEVEL_LANG ?= verilog

#### Declare the simulator to be used
SIM ?= icarus

#### Tell cocotb where our HDL source files are
# "+=" will append to the variable instead of replacing previous contents
VERILOG_SOURCES = $(shell pwd)/../hdl/sb_cla.sv
VERILOG_SOURCES += $(shell pwd)/../hdl/4b_cla.sv
VERILOG_SOURCES += $(shell pwd)/../hdl/8b_cla.sv

#### Tell Python the module that contains the test functions to perform on the DUT
MODULE = test_cla

#### Declare the top-level module (synonmous with DUT, component, and instance) in the design
TOPLEVEL = cla_8b

#### Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
