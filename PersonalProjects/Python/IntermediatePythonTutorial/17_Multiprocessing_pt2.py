# Multiprocessing example: Share a single array across multiple processes
from multiprocessing import Process, Array, Lock
import time


# The 'do stuff' function
def add_100(numbers, lock):  # Add 100 to each element of the array for each process of the function
    for i in range(100):
        time.sleep(0.01)
        for i in range(len(numbers)):
            with lock:
                numbers[i] += 1


if __name__ == "__main__":  # If in the main module

    lock = Lock()                                    # To avoid race conditions, create lock object
    shared_array = Array('d', [0.0, 100.0, 200.0])   # Create array to use across multiple processes
    print('Array at beginning is', shared_array[:])  # Print beginning array

    # Create process objects using the created 'do stuff' function above
    p1 = Process(target=add_100, args=(shared_array, lock))  # Arguments will be in the form of tuples
    p2 = Process(target=add_100, args=(shared_array, lock))  # The arguments are the shared array and lock

    # Start processes
    p1.start()
    p2.start()

    # Join processes
    # Wait for all processes to finish while holding off on the main process - This is the main process
    p1.join()
    p2.join()

    # Print value after all processing
    print('Array at end is', shared_array[:])  # Each element of the array should have increased by 200
