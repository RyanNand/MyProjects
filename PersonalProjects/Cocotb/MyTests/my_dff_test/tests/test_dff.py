# Import the necessary modules to perform the test on the DUT
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from itertools import permutations

# Create a model to self-check the results of the simulation
def my_dff_model(a: int, b: int) -> int:
    """The model simply returns the input "a" if active-low reset is high; otherwise, we get a 0"""
    if b == 1:
        return a
    else:
        return b


# Create a coroutine function (aka test function)
@cocotb.test()
async def my_test_dff(dut):
    """Testing rising edge flip-flop with negative edge active-low reset"""

    #### Create and start clock with concurrent coroutine operation
    # Clock with 50% duty cycle and a period of 10ps
    cocotb.fork(Clock(dut.clk, 10, "ps").start())

    # Syncronize with the clock
    await RisingEdge(dut.clk)

    #### Generate transactions
    # In this case, all possible combinations in every consecutive order 
      # 2 inputs (D and rstN) = 4 possible binary combinations (00, 01, 10, 11) => 2^4 = 16 possible combinations in every consecutive order
    # Declare the number of inputs
    num_of_inputs = 2
    # Create a list of permutations for those two inputs (list: [(0, 1), (1, 0)])
    transactions = list(permutations(range(num_of_inputs), 2))
    # Permutations do not account for repeat value combinations; so add those in to get (list: [(0, 1), (1, 0), [0, 0], [1, 1]]) the 4 possible binary combinations
    for i in range(num_of_inputs):
        transactions.append([i, i])
    # Create a list of permutations on top of the list of permutations to account for the "in every consecutive order" part
    transactions = list(permutations(transactions, 2))
    # Again, we must add in the missed repeat value combinations; there were 4 missed this time instead of the 2 above
    for i in range(num_of_inputs):
        transactions.append(([i, i], [i, i]))
        if i == 1:
            transactions.append(([i, 0], [i, 0]))
            transactions.append(([0, i], [0, i]))

    # Run the simulation with the transactions generated
    for i in range(len(transactions)):

        # Assign the stimulus to the DUT's ports
        dut.D    <= transactions[i][0][0]
        dut.rstN <= transactions[i][0][1]
        
        # Simulate some small time (less than half the period) for the random integers to reach the DUT's input ports
        await Timer(1, "ps")
        #print(f"The D input: {dut.D.value}")
        #print(f"The rstN input: {dut.rstN.value}")
        
        # Detect the falling edge of clock 
        await FallingEdge(dut.clk)

        # Simulate some small time (less than half the period) for the output to update accordingly after the falling edge (aka if reset is low)
        await Timer(1, "ps")
        #print(f"The output after the falling edge: {dut.Q.value}")

        # Detect the rising edge of clock
        await RisingEdge(dut.clk)

        # Simulate some small time (less than half the period) for the output to update accordingly after the rising edge (aka if "D" is different than "Q")
        await Timer(1, "ps")
        #print(f"The output after the rising edge: {dut.Q.value}")

        # Assert an error message and stop simulation if the output does not match the model's output
        assert dut.Q.value == my_dff_model(transactions[i][0][0], transactions[i][0][1]), f"Failure: Transaction - {transactions[i][0]} failed!"

        #### There is a double simulation per "for" loop because of how the transaction was built 
        # Assign the stimulus to the DUT's ports
        dut.D    <= transactions[i][1][0]
        dut.rstN <= transactions[i][1][1]

        #Simulate some small time (less than half the period) for the random integers to reach the DUT's input ports
        await Timer(1, "ps")
        #print(f"The D input: {dut.D.value}")
        #print(f"The rstN input: {dut.rstN.value}")

        # Detect the falling edge of clock
        await FallingEdge(dut.clk)

        # Simulate some small time (less than half the period) for the output to update accordingly after the falling edge (aka if reset is low)
        await Timer(1, "ps")
        #print(f"The output after the falling edge: {dut.Q.value}")

        # Detect the rising edge of clock
        await RisingEdge(dut.clk)

        # Simulate some small time (less than half the period) for the output to update accordingly after the rising edge (aka if "D" is different than "Q")
        await Timer(1, "ps")
        #print(f"The output after the rising edge: {dut.Q.value}")


        assert dut.Q.value == my_dff_model(transactions[i][1][0], transactions[i][1][1]), f"Failure: Transaction - {transactions[i][1]} failed!"

