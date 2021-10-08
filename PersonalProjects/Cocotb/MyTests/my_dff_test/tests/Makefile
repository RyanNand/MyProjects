# Declare the HDL used in the design
TOPLEVEL_LANG ?= verilog

# Declare the simulator to be used
SIM ?= icarus


# Tell cocotb where our HDL source files are
VERILOG_SOURCES = $(shell pwd)/../hdl/dff.sv


# Tell Python the module that contains the test functions to perform on the DUT
MODULE = test_dff

# Declare the top-level module (synonmous with DUT, component, and instance) in the design
TOPLEVEL = dff

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
