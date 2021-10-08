#### Import the necessary modules to perform the test on the DUT
# Import the "Clock" class from the "cocotb.clock" module
  # A class that generates a clock driver
# Import the "FallingEdge" class from the "cocotb.triggers" module
  # A class that fires a trigger when a falling edge is detected on a specified signal
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

#### Create a coroutine function to perform the first and only test
@cocotb.test()
async def test_dff_simple(dut):
    # The first triple quotes comment right below the function declaration identifies a description of the test function; this will be reported in the test report
    """Test if d propagates to q"""
    
    #### Create a clock
    # "Clock(...)" is a cocotb class that will generate a simple 50% duty cycle clock driver
      # There are three arguments: first is the signal to drive the clock on, second is the period as an even integer, third is the units as a string
      # "ns" - nanoseconds, "ps" - picoseconds, "us" - microseconds, "ms" - milliseconds, "fs" - femtoseconds, "sec" - seconds, "step" - let simulator decide
    clock = Clock(dut.clk, 10, "us")

    #### Start the clock
    # "cocotb.fork(...)" is a function that enables or schedules concurrent coroutines
      # There is a single argument and the argument is the coroutine that you wish to be running concurrently
    # "clock.start()" is a coroutine function to start driving the clock that was previously created
      # The creation and forking of the clock can happen in one line "cocotb.fork(Clock(dut.clk, 10, "us").start())"
    cocotb.fork(clock.start())

    #### Simulate until the first falling edge to synchronize with the clock
    # "FallingEdge(...)" is a cocotb class that fires a trigger when a falling edge is detected on a specified signal
      # There is a single argument and the argument is the specified signal to detect the falling edge from
    await FallingEdge(dut.clk)

    #### Generate ten transactions of constrained random stimulus and test the DUT
    for i in range(10):
        #### Create a port variable to hold the constrained random stimulus
        val = random.randint(0, 1)
        #### Drive the DUT's port with the constrained random stimulus
        dut.d <= val
        #### Simulate until the next falling edge or simulate a period
        await FallingEdge(dut.clk)
        #### Assert an error message in the report if the input of the dff does not propagate through to the output within the period
        assert dut.q.value == val, "output q was incorrect on the {} cycle".format(i)
