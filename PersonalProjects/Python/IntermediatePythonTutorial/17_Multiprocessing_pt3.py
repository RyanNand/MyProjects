# Multiprocessing example: Using a queue
# The queue is not like sharing a variable across multiple processes, it's more like sharing a stack of memory
# Load the stack when we "put()" and pop the stack when we "get()", a FIFO data structure
from multiprocessing import Queue  # FIFO data structure
from multiprocessing import Process, Value, Array, Lock
import time


# A function to 'do stuff' - Square the numbers in the queue
def square(numbers, queue):
    for i in numbers:
        queue.put(i*i)  # Insert new value into queue


# A function to 'do stuff' - Make the numbers in the queue negative
def make_neg(numbers, queue):
    for i in numbers:
        queue.put(-1*i)  # Insert new value into queue


if __name__ == "__main__":  # If in the main module

    numbers = range(1, 6)  # Create a list from 1 to 5
    print(f'These are the passed values: {list(numbers)}')
    q = Queue()            # Create a queue object

    # Create process objects using the created 'do stuff' functions above
    p1 = Process(target=square, args=(numbers, q))    # 'Square' function with "numbers" and the queue as arguments
    p2 = Process(target=make_neg, args=(numbers, q))  # 'make_neg' function with "numbers" and the queue as arguments

    # Start processes
    p1.start()
    p2.start()

    # Join processes
    # Wait for all processes to finish while holding off on the main process - This is the main process
    p1.join()
    p2.join()

    # Print the queue elements after all processing
    # Squared values should show first since that is the first process and lock prevents race conditions of the queue
    # Afterwards the negative values should show up
    while not q.empty():
        print(q.get())  # Remove and print value from queue
