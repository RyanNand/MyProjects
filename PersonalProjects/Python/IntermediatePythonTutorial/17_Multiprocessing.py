# Multiprocessing example: Share a single value across multiple processes
from multiprocessing import Process, Value, Lock
import time


# The 'do stuff' function
def add_100(number, lock):  # Adds 100 for each process of the function
    for i in range(100):
        time.sleep(0.01)
        # lock.acquire() The "with" statement makes this line useless
        with lock:
            number.value += 1
        # lock.release() The "with" statement makes this line useless


if __name__ == "__main__":  # If in the main module

    lock = Lock()                                         # To avoid race conditions, create lock object
    shared_number = Value('i', 0)                         # Create the value to use across multiple processes
    print('Number at beginning is', shared_number.value)  # Print beginning value

    # Create process objects using the created 'do stuff' function above
    p1 = Process(target=add_100, args=(shared_number, lock))  # Arguments will be in the form of tuples
    p2 = Process(target=add_100, args=(shared_number, lock))  # The arguments are the shared number object and lock

    # Start processes
    p1.start()
    p2.start()

    # Join processes
    # Wait for all processes to finish while holding off on the main process - This is the main process
    p1.join()
    p2.join()

    print('Number at end is', shared_number.value)  # Print value after all processing - Should be 200 for 2 processes
