#### Import the necessary modules to perform the test on the DUT
# Import the "warnings" module
  # This module makes it easier report issues to the user under certain situations using the provided functions
# Import the "BinaryValue" class from the "cocotb.binary" module
  # This class makes it easier to represent values in binary format; for example, string/integer values to binary
# Import the "TestFactory" class from the "cocotb.regression" module
  # This class makes it possible to automatically generate sets of tests based on different permutations of possible arguments to the test function
  # This comes in handy when there are multiple transactions, features, and/or backpressure (backpressure is things that slow down data flow, ex. user input or clock)
# Import the "Monitor" class from the "cocotb_bus.monitors" module
  # Similar to the UVM monitor class where the component observes the pin wiggling going in/out of the DUT; then communicates with the scoreboard for analysis
    # This class should not be used directly, but should be sub-classed and the internal "_monitor_recv()" function should be overridden
    # This "_monitor_recv()" function should capture some behavior of the pins, form a transaction, and pass this transaction to the internal "_recv(...)" method
    # (disregard??) The "_monitor_recv()" method is added to the cocotb scheduler during the "__init__" phase, so it should not be awaited anywhere
# Import the "BitDriver" class from the "cocotb_bus.drivers" module
  # Similar to cocotb's "Driver" class within the same module in that they both drive transactions onto the DUT's interface; however, this one drives a single bit
  # Both classes may consume simulation time
  # The "BitDriver" class comes in handy for exercising ready/valid flags
# Import the "Scoreboard" class from the "cocotb_bus.scoreboard" module
  # Similar to the UVM scoreboard in that they both communicate with the monitor and analyzes the transactions from the DUT; an expected output queue must be given
  # The expected output can either be a function which provides a transaction or a simple list containing the expected output
import random
import warnings

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.binary import BinaryValue
from cocotb.regression import TestFactory

from cocotb_bus.monitors import Monitor
from cocotb_bus.drivers import BitDriver
from cocotb_bus.scoreboard import Scoreboard

#      dut
#    ________
#    |      |
#  --| d  q |--
#    |      |
#  --|>c    |
#    |______|

#### Create the sub-class of the monitor class and override "_monitor_recv()" following the guidelines above
# In Python, to create a sub-class we must pass the inherited class's name as an argument; in this case, the inherited class is "Monitor"
class BitMonitor(Monitor):
    """Observe a single-bit input or output of the DUT."""
    #### Build the "__init__(...)" of the class (not a constructor); this overrides the parent's init
    # "Monitor.__init__(self, callback, event)" must be inside the child's init to preserve the parent's init
      # "super().__init__(...)" can be used instead as well; this preserves everything (methods and properties) from the parent's class
    def __init__(self, name, signal, clk, callback=None, event=None):
        self.name = name
        self.signal = signal
        self.clk = clk
        Monitor.__init__(self, callback, event)

    #### Override the "_monitor_recv()" function as per the guidelines
    # This "_monitor_recv()" function should capture some behavior of the pins, form a transaction, and pass this transaction to the internal "_recv(...)" method
    # We are capturing the rising edge of "clk" using the "RisingEdge(...)" trigger from cocotb; then retreiving a signal value to form a transaction
    # Afterwards we send the transaction to the "_recv(...)" function
    async def _monitor_recv(self):
        while True:
            await RisingEdge(self.clk)
            vec = self.signal.value
            self._recv(vec)

#### Declare a function to form the transactions
# Using a Python generator to do what the "BitDriver" class requests for the "generator" parameter
# The generator should yield tuples (on, off) with the number of cycles to be on, followed by the number of cycles to be off; typically generator should go on forever
  # "while True" is a infinite "while" loop
  # The generator "yield random.randint(1, 5), random.randint(1, 5)" will generate a tuple (x, y) where x and y are random integers in the range of 1-5; inclusive
def input_gen():
    while True:
        yield random.randint(1, 5), random.randint(1, 5)

#### Create the testbench test class; this is similar if not identical to the UVM test class/component 
class DFF_TB():
    #### Build the initialization function
    # Will pass in a reference to the DUT and a initial value for the monitor as explained in the comment right below
    # So from my understanding lines like "self.init_val = init_val" are only necessary if they are referenced outside of the class (ex. class_obj_name.init_val)
      # Inside the class, using "self.init_val" or just "init_val" is equivalent
      # In other words and in this case, lines "self.dut = dut" and "self.init_val = init_val" can be omitted
    def __init__(self, dut, init_val):
        """
        Setup the testbench.
        *init_val* signifies the ``BinaryValue`` which must be captured by the output monitor with the first rising clock edge.
        This must match the initial state of the D flip-flop in RTL.
        """
        # Initialize internal variables
        self.stopped = False

        #### Create the driver and output monitor components
        # The left operands are arbitrary
        # The right operands are the imported driver "BitDriver(...)" class and our created "BitMonitor(...)" sub-class
          # Both class instantiations have key (not positional) arguments; so be aware!!!
        # We connect the DUT with the driver here and also send in the transaction generator function that was created above
        self.input_drv = BitDriver(signal=dut.d, clk=dut.c, generator=input_gen())
        self.output_mon = BitMonitor(name="output", signal=dut.q, clk=dut.c)

        #### Create the scoreboard component
        # Create the simple list of expected outputs as needed and requested for the scoreboard component
          # Can also be a function that builds transactions for the expected outputs
          # Initialized with init_val as the first element
        # "with" is a Python statement that makes it possible to factor out "try"/"finally" statements
          # Have examples for "try"/"finally"  in exceptions and "with" in multithreading
          # The "with" statement intiates the "__enter__()" and "__exit__()" methods on entry and exit to/from the body of the statement
        # "warnings.catch_warnings()" is a context manager within the "warnings" class for suppressing warnings temporarily
        # "warnings.simplefilter(...)" is a function within the "warnings" class that inserts a simple entry into the list of warnings filter specifications
          # The warnings filter spec controls whether warnings are ignored, displayed, or turned into errors
          # Pass in a 'action' string; there can be other arguments passed but it's not necessary
            # "ignore" - never print matching warnings
            # "always" - always print matching warnings
            # "error" - turn matching warnings into exceptions
            # "module" - print the first occurrence of matching warnings for each module where the warning is issued (regardless of line number)
            # "once" - print only the first occurrence of matching warnings, regardless of location
            # "default" - print the first occurrence of matching warnings for each location (module + line number) where the warning is issued
        # In other words, not sure what warnings we are expecting here for the creation of the scoreboard but we will be ignoring them regardless
          # Another testbench as the same process for building the scoreboard
        # Use the imported "Scoreboard(...)" class to instantiate/create the component; pass in the reference to the DUT like the documentation states
        # "add_interface(...)" is a function within the "Scoreboard" class that connects the monitor to the scoreboard and compares the output and the expected output
          # Pass in the references to the monitor and the expected output
          # Be aware that the object name "self.scoreboard" is to be used in place of "Scoreboard" in "Scoreboard.add_interface(...)"
        self.expected_output = [init_val]
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            self.scoreboard = Scoreboard(dut)
        self.scoreboard.add_interface(self.output_mon, self.expected_output)

        # Use the input monitor to reconstruct the transactions from the pins
        # and send them to our 'model' of the design.
        #### Create the input monitor component
        # Used the created sub-class monitor "BitMonitor" which inherited the parent class "Monitor" from the "cocotb_bus.monitors" module
          # The argument is similar to the output monitor; however, a model was also passed
          # We created a model that inspects the input applied to the DUT and then appends the model's output to the expected output list
        self.input_mon = BitMonitor(name="input", signal=dut.d, clk=dut.c, callback=self.model)

    #### Create a model of the DUT to append expected values to the expected output list which then gets used by the scoreboard for comparison
    # This model will be used as a callback function for the input monitor instantiated above
    # Cocotb will automatically pass in the transaction to this callback everytime the created input monitor "input_mon" has a new transaction to pass
    # There is a stopping mechanism we designed "if not self.stopped" then do not append to expected output list
      # In other words, if "self.stopped" is 'True' do not append
    def model(self, transaction):
        """Model the DUT based on the input *transaction*.
        For a D flip-flop, what goes in at "d" comes out on "q", so the value on "d" (put into *transaction* by our "input_mon") 
        can be used as expected output without change. Thus we can directly append *transaction* to the "expected_output" list,
        except for the very last clock cycle of the simulation (that is, after "stop()" has been called).
        """
        if not self.stopped:
            self.expected_output.append(transaction)

    #### Create the stopping mechanism for data generation and the appending process for the expected output list
    # "BitDriver_class_obj_name.start()" is a function within the "BitDriver" class that starts the data generator which was passed into the driver instantiation
      # In this case, "BitDriver_class_obj_name" = "input_drv"
    def start(self):
        """Start generating input data."""
        self.input_drv.start()
    #### Continue building the stopping mechanism
    # "BitDriver_class_obj_name.stop()" is a function within the "BitDriver" class that stops the data generator which was passed into the driver instantiation
      # The same object name is applied as above
    # We also set "self.stopped" to 'True' which will stop the model from appending more values as mentioned above
    def stop(self):
        """Stop generating input data.
        Also stop generation of expected output transactions.
        One more clock cycle must be executed afterwards so that the output of
        the D flip-flop can be checked.
        """
        self.input_drv.stop()
        self.stopped = True

#### Build the common test function that puts all of parts above together
# The common test function must take the reference to the DUT as the first argument
async def run_test(dut):
    """Setup testbench and run a test."""

    #### Create and start the concurrent clock
    # "start_high" is a argument to the "start()" function within the "Clock" class that starts the clock high if set to 'True' or low if 'False'; 'True' is the default
    cocotb.fork(Clock(dut.c, 10, 'us').start(start_high=False))

    #### Create/instantiate the testbench
    # Pass in the DUT reference and a initial value of '0' for the expected output list's first element
    tb = DFF_TB(dut, init_val=BinaryValue(0))

    # Create a variable that detects a rising edge trigger
    clkedge = RisingEdge(dut.c)

    #### Apply random input data by input_gen via BitDriver for 100 clock cycles
    # This is done by using the created "start()" function from the created "DFF_TB" class
    tb.start()
    # A 'for' loop to cycle through 100 clock cycles
    for _ in range(100):
        await clkedge

    #### Stop generation of input data; one more clock cycle is needed to capture the resulting output of the DUT.
    # This is done by using the created "stop()" function from the created "DFF_TB" class
    tb.stop()
    # The extra clock cycle that is needed to capture the result
    await clkedge

    #### Print result of scoreboard
    # "Scoreboard.result" is a property within the "Scoreboard" class that simply returns a test failure if the expected output does not match the simulated output
    raise tb.scoreboard.result


#### Register the test with the factory
# "TestFactory(...)" is a function within the "TestFactory" class that registers the common test function 
# "TestFactory.generate_tests()" is a function with the "TestFactory" class that automatically generates the set of tests mentioned at the top and below for reiteration
  # This class makes it possible to automatically generate sets of tests based on different permutations of possible arguments to the test function
  # This comes in handy when there are multiple transactions, features, and/or backpressure (backpressure is things that slow down data flow, ex. user input or clock)
  # To build sets with multiple options; we would use the "TestFactory.add_option(...)" function from the "TestFactory" class inbetween the register and generate lines
factory = TestFactory(run_test)
factory.generate_tests()
