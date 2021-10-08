#### Import the necessary modules to perform the test on the DUT
import cocotb
from cocotb.triggers import Timer
from itertools import permutations 

#### Declare the number of bits the DUT can accept
# This has to be the bit widths of the adder ports A, B, and S; otherwise, the model does not work correctly
# The default and what the makefile targets is a 8-bit carry look-ahead adder
BITS = 8

#### Create a model to compare the DUT's simulations results with
def my_adder_model(a: int, b: int, c: int, d: int) -> int:
    """Model of adder!!"""
    #### Simply add together the inputs
    a = a + b + c
    #### If overflow
    if a >= (2 ** d):
        #### Subtract the largest value that can be represented by the bit widths set above and then return the value
        return [a - (2 ** d), 1]
    #### Otherwise, just return the original addition total
    else:
        return [a, 0]

#### Create a coroutine function to perform the first test
@cocotb.test()
async def all_possible_comb(dut):
    """Test all possible input combinations"""

    #### Generate our transactions to send to the DUT
    # Get the total number of bit combinations this bit width can represent
    num_of_comb = 2 ** BITS

    #### Create all possible ordered combinations (aka permutation) from 0 to ("num_of_comb" - 1)
    # Will create a list of tuples; each tuple is of length 2 (ex. transactions =  [(0, 1), (1, 0)])
    transactions = list(permutations(range(num_of_comb), 2))
    
    #### Since permutations do not account for repeat combinations (ex. [(0, 0), (1, 1)]), we must add that to our transactions manually
    # First allocate an empty list
    transactions_repeat = []
    # Create a "for" loop to iterate through 0 to ("num_of_comb" - 1)
    for i in range(num_of_comb):
        # Append to the list the repeat combination
        transactions_repeat.append([i, i])
    # Concatenate the repeat combinations into our main transaction variable
    transactions = transactions + transactions_repeat

    #### Now we must account for the carry-in input
    # Allocate lists for when carry-in is low and when carry-in is high; so that we can concatenate all of them at the end of the process
    transactions_Cin_low  = []
    transactions_Cin_high = []
    # Create a "for" loop to iterate through the length of the transaction variable (aka number of permutations plus repeat combinations)
    for i in range(len(transactions)):
        # Here we have to convert the tuples within the transaction list to lists for us to be able to append; tuples are immutable
        transactions_Cin_low.append(list(transactions[i]))
        # Now we can append a value for carry-in to be low for each transaction
        transactions_Cin_low[i].append(0)
    # Create a "for" loop to iterate through the length of the transaction variable
    for i in range(len(transactions)):
        # Convert the list of tuples into a list of lists again
        transactions_Cin_high.append(list(transactions[i]))
        # Now we can append a value for carry-in to be high for each transaction
        transactions_Cin_high[i].append(1)
    # In the end, we can concatenate the carry-in low transactions with the carry-in high transactions
    transactions = transactions_Cin_low + transactions_Cin_high

    #### Send the stimulus/transactions to the DUT
    for i in range(len(transactions)):
        dut.A   <= transactions[i][0]
        dut.B   <= transactions[i][1]
        dut.Cin <= transactions[i][2]
        
        #### Simulate for 1 simulator defined unit
        await Timer(1, "step")
        
        #### Print inputs/outputs if needed
        #print(f"A = {int(dut.A.value)}, B = {int(dut.B.value)}, Cin = {int(dut.Cin.value)}, results = {int(dut.S.value)}, carry_out = {dut.Cout.value}")
        
        #### Assert an error if DUT's output does not match the model's output
        result = my_adder_model(transactions[i][0], transactions[i][1], transactions[i][2], BITS)
        # Account for the sum
        assert dut.S.value == result[0], "Failure: The sum is not correct!!!!"
        # Account for the carry-out
        assert dut.Cout.value == result[1], "Failure: The carry-out is not correct!!!!"
