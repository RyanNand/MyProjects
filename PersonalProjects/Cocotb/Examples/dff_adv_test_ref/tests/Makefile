# Declare a varible to hold the current working directory; to help find the HDL source files
CWD=$(shell pwd)

# Declare the HDL we used in the design
TOPLEVEL_LANG ?=verilog

# Tell cocotb where the source files based on the HDL used; if invalid HDL then print error message
ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES =$(CWD)/../hdl/dff.v
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES =$(CWD)/../hdl/dff.vhdl
else
  $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

# Declare the top-level module (synonmous with DUT, component, and instance) in the design
TOPLEVEL = dff

# Tell Python the module that contains the test functions to perform on the DUT
MODULE := $(TOPLEVEL)_cocotb

#### Declare the default time unit and time precision this verification test should use
# "COCOTB_HDL_TIMEUNIT" is a cocotb variable that sets the default time unit for simulation when not specified by modules in the design 
  # If this variable isn't specified then it is assumed to be "1ns"
  # Allowed values are 1, 10, and 100
  # Allowed units are the usual: "s", "ms", "us", "ns", "ps", "fs"; but not "step" obviously
# "COCOTB_HDL_TIMEPRECISION" is a cocotb variable that set the default time precision for simulation when not specified by modules in the design 
  # If this variable isn't specified then it is assumed to be "1ps"
  # Allowed values are 1, 10, and 100
  # Allowed units are the usual: "s", "ms", "us", "ns", "ps", "fs"; but not "step" obviously
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

#### Declare the dependancies for the simulation
# "CUSTOM_SIM_DEPS" is a cocotb variable used to add additional dependencies to the simulation target
CUSTOM_SIM_DEPS=$(CWD)/Makefile

#### Define some simulator specific arguments or flags
# If using Questa Sim, define the timescale/precision (command-line agrument "-t") as "1ps"; Questa Sim refers to this as simulator resolution
ifeq ($(SIM),questa)
    SIM_ARGS=-t 1ps
endif

#### Define some simulator specific arguments or flags
# "filter" is a makefile defined function that takes words from the text (second argument) and returns the ones that do match with the first argument's content
  # The ones that are not matched are removed
# "ifeq(...)" is makefile's 'if not equal to'; has the same rules as "ifeq(...)" but the difference is that it will only occur if they are not equal to each other
  # There are two arguments; first is a variable referencing the value to be compared, and the second argument is the value to which the first is to be compared with
# In other words, if the "SIM" variable holds "ius", "xcelium" or both then proceed to append "SIM_ARGS" with "-v93"
  # "-v93" is an argument to specify which version of the simulator to use 
ifneq ($(filter $(SIM),ius xcelium),)
    SIM_ARGS += -v93
endif

# Include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
