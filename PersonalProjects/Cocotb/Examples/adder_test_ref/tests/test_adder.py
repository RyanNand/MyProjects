# Cocotb documentation website: https://docs.cocotb.org/en/stable/index.html

#### Import the necessary modules to perform the test on the DUT
# Import "cocotb" for the base cocotb module
# Import the "Timer" class from the "cocotb.triggers" module
  # Triggers are used to indicate when the cocotb scheduler should resume coroutine execution vs. simulator execution
# Import our model module for the ideal adder
# Import the random module to perform with random numbers
# Looks like we use "from ... import ..." if the module is not within either Python's default base library directory or Python's "site-packages" directory
  # The default base library can be found with the following path: lib/python3.8
  # The "site-packages" directory can be found with the following path: /home/ryan/.local/lib/python3.8/site-packages
import cocotb
from cocotb.triggers import Timer
from adder_model import adder_model
import random

#### Create a function to perform the first test
# "@cocotb.test(...)" is a cocotb decorator to mark the test function to perform on the DUT
  # There are arguments to this decorator that add features like skip test, add a timeout, stage the ordering, or expecting failure so don't mark as a failure
    # Most of these features will most likely not be used; however, if needed refer to the documentation for details
# "async" is a Python keyword used to declare coroutine functions which are the foundation of cocotb testbenches; cocotb runs on coroutines
  # Every coroutine must contain an "await" statement
  # "await" is a Python keyword used to awake from the coroutine execution and give control back to the simulator; coroutines pause simulations 
# "dut" is a cocotb handle; when cocotb initializes it finds the top-level instantiation in the simulator and creates this handle
  # Must pass this handle in to the coroutine function in order to access the DUT's ports
@cocotb.test()
async def adder_basic_test(dut):
    """Test for 5 + 10"""

    #### Declare stimulus variables and initialize them
    A = 5
    B = 10

    #### Assign the stimulus to the DUT's ports
    # Access to the DUT's ports are done by the dot operator
    dut.A <= A
    dut.B <= B

    #### Run simulation for 2ns, then come back to coroutine execution
    # "Timer(...) is a cocotb trigger that will run simulation until the allotted time and return control to the cocotb coroutine
      # There are two arguments; first is the desired allotted simulation time as an integer, second is the units as a string
        # "ns" - nanoseconds, "ps" - picoseconds, "us" - microseconds, "ms" - milliseconds, "fs" - femtoseconds, "sec" - seconds, "step" - let simulator decide
    await Timer(2, units='ns')

    #### Display the operands and the results of the adder
    # Code that Ryan added for testing cocotb functionality
    print(f"A = {A}, B = {B}, result = {int(dut.X.value)}")

    #### Display an error message if the simulated adder result does not match the ideal model's result
    # "assert" is a Python keyword to throw an error message if the condition is NOT met; won't stop execution of the program regardless if assertion is thrown or not
      # There are two parts to an assertion statement; first part is the conditional, second part is the message to report
    assert dut.X.value == adder_model(A, B), "Adder result is incorrect: {} != 15".format(int(dut.X.value))

#### Create a function to perform the second test
@cocotb.test()
async def adder_randomised_test(dut):
    """Test for adding 2 random numbers multiple times"""
    
    #### Loop 10 times for 10 transactions
    for i in range(10):

        #### Declare variables and initialize them to implement constrained random stimulus
        A = random.randint(0, 15)
        B = random.randint(0, 15)

        #### Assign the constrained random stimulus to the DUT's ports
        dut.A <= A
        dut.B <= B

        #### Run the simulation for 2ns, then come back to coroutine execution
        await Timer(2, units='ns')
        
        #### Display the operands and the results of the adder
        # Code that Ryan added for testing cocotb functionality
        print(f"A = {A}, B = {B}, result = {int(dut.X.value)}")

        #### Display an error message if the simulated adder results does not match the ideal model's results
        assert dut.X.value == adder_model(A, B), "Randomised test failed with: {A} + {B} = {X}".format(
            A=dut.A.value, B=dut.B.value, X=dut.X.value)
