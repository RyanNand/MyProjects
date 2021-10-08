# GNU documentation - https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents
# A GNU Make is a tool that controls the generation of executables (aka makefile)
  # Consider this a unique language specifically made for makefiles
    # Every comment is for this unique makefile language; unless, prefaced by a reference to cocotb or stated otherwise 
  # There are two phases on how the "make" reads a makefile
    # First phase: read all makefiles involved, internalize all variables/values and implicit/explicit rules, and build dependency graph of all targets/their prereqs
    # Second phase: determine which targets need to be updated and run the recipes to update them

#### Declare the HDL we used in the design
# "?=" this operator will only set the variable to the right operand if it's not already set to something else 
# "TOPLEVEL_LANG" is a cocotb variable used to inform the makefile scripts which HDL language the top-level design element is written in
  # Currently it supports the values verilog for Verilog or SystemVerilog tops, and vhdl for VHDL tops
  # This is used by simulators that support more than one interface (VPI, VHPI, or FLI) to select the appropriate interface to start cocotb
  # The variable is also made available to cocotb tests conveniently as cocotb.LANGUAGE
TOPLEVEL_LANG ?= verilog

#### Declare the default simulator to use
# "SIM" is a cocotb variable that selects which simulator Makefile to use 
  # Attempts to include a simulator specific makefile from cocotb/share/makefiles/simulators/makefile.$(SIM)
SIM ?= icarus

# Below is an example of using "=" vs ":=" and what the result would be
  # Does not matter what type the "a" variable uses; "b" will still have the same results
  # "all:;"
# a = foo                                                  a = foo
# b = $(a) bar                                             b := $(a) bar
# a = apple                                                a = apple

# all:;echo $(b)  # Prints apple bar                       all:; echo $(b)  # Prints foo bar

#### Set a variable to point to our current working directory
# pwd - print/retrieve current working directiory
# ":=" Simply expanded variable; acts like a variable in most programming languages where it isn't automatically updated with a new value from a future assignment
# "=" Recursively expanded variable; if the right hand operand references another variable it will expand to whatever that other variable points to at the end of make
  # Another major feature is that this will expand the variable everytime it is used; causing this "make" to run slower
# "$(...)" This can be a variable reference or a function call depending on the contents within the parantheses
  # Function call syntax: $(function arguments) where "function" is the function name and "arguments" are the arguments you want to pass in separated by a comma
  # Variable references are used like in the example above for variable "b"
# "shell" one of two functions that communicates outside of "make". This is equivalent to running a command line prompt outside of "make"
  # Spawns a new shell; therefore, using it with a recursively expanded variable slows the process. Instead use the simply expanded variable
# "warning" The function will display the message in the argument, but will still run the program
  # "error" This function will display the message in the argument and stop the program
# "PWD" is a arbitrary variable that is used to provide the rest of the makefile code the current working directiory for this makefile
PWD:=$(warning Invoking the shell)$(shell pwd)

#### Tell Python where our model for the correct results is
# "export" is a function used to export specific variables to the sub-"make"
  # sub-"make" is referring to the recursive use of "make" in another directory
# "PYTHONPATH" is a Python environment variable that tells python where in the directory to search for modules or libraries to use
  # The variable is equivalent to the "PATH" environment variable except that it's specific to Python
# "/.." The double periods tells the processor to move back a directory level or folder in the file system
# In this case, we are exporting a variable called "PYTHONPATH" that will append to the existing "PYTHONPATH" environment path variable the directory that's assigned
  # In other words, "$(PWD)/../model" is added to the environment path variable "PYTHONPATH"
  # The exported variable is not the same as the referenced environment path variable "PYTHONPATH"
export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

#### Tell cocotb where our HDL source files are depending on the language we used
# "ifeq(...)" starts the if-else conditional statements; equivalent to 'if' in most other programming languages, but still has different syntax; so be aware!!!
  # There are two arguments; first is a variable referencing the value to be compared, and the second argument is the value to which the first is to be compared with
# "else ifeq(...)" add more conditional statements; equivalent to 'else if' in most other programming languages. Has the same two arguments as the previous "ifeq(...)"
# "else" will occur if the previous conditional statements fail; has the same meaning with 'else' in most other programming languages. Has no arguments
# "endif" this will end the conditional statement and this is required; this is unlike most programming languages with conditionals; so be aware!!!
ifeq ($(TOPLEVEL_LANG),verilog)
    # "VERILOG_SOURCES" is a cocotb variable that contains the list of the Verilog source files to include
      # Paths can be absolute or relative; if relative, they are interpreted as relative to the Makefile’s location
      # We can append to the variable multiple source files using the append assignment operator
        # "+=" is the append assignment operator; this operator will append to the contents of the variable instead of replacing the contents
    VERILOG_SOURCES = $(PWD)/../hdl/adder.sv
else ifeq ($(TOPLEVEL_LANG),vhdl)
    # "VHDL_SOURCES" is a cocotb variable that contains the list of the VHDL source files to include
      # Paths can be absolute or relative; if relative, they are interpreted as relative to the Makefile’s location
    VHDL_SOURCES = $(PWD)/../hdl/adder.vhdl
else
    $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

#### Declare the top-level module (synonmous with DUT, component, and instance) in the design
# "TOPLEVEL" is a cocotb variable used to indicate the instance in the hierarchy to use as the DUT
  # If this isn’t defined then the first root instance is used
  # The DUT is available in cocotb tests as a Python object at cocotb.top; and is also passed to all cocotb tests as the first and only parameter
TOPLEVEL := adder

#### Tell Python the module that contains the test functions to perfom on the DUT
# "MODULE" is a cocotb variable that contains the name of the Python module(s) to search for test functions
  # If your tests are in a file called test_mydesign.py, MODULE would be set to test_mydesign 
  # Multiple modules can be specified using a comma-separated list
  # All tests will be run from each specified module in order of the module’s appearance in this list
  # This is the only environment variable that is required for cocotb, all others are optional
MODULE   := test_adder

#### Include cocotb's make rules to take care of the simulator setup
# "include" will suspend reading the current makefile and read one or more other makefiles before continuing
# "cocotb-config" is a cocotb script for locating various cocotb related configurations
# "--makefiles"  is a cocotb argument; when used in conjunction with "cocotb-config" it will print the path for the cocotb makefiles
# "Makefile.sim" is a cocotb makefile full of rules to setup the simulator
include $(shell cocotb-config --makefiles)/Makefile.sim
