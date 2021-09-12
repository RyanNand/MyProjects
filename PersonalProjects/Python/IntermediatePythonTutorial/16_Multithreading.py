# Threading examples
from threading import Thread, Lock
import time

# Create value to increase with the function below
database_value = 0


# Function for "target=" in the "Thread()" function below
# The function to 'do stuff' in multiple threads
def increase(lock):
    global database_value  # Create global variable that will increase within the function
    with lock:
    #lock.acquire()  "with lock: makes this state useless
        local_copy = database_value
        # Processing
        local_copy += 1
        time.sleep(0.1)
        database_value = local_copy
    #lock.release()  "with lock:" makes this statement useless


if __name__ == "__main__":  # If in the main module
    lock = Lock()           # To prevent the race condition where end value is 1 when it should be 2
    print('Start value', database_value)

    # Create two or more thread objects
    thread1 = Thread(target=increase, args=(lock,))  # Argument to the "increase()" function above is "lock"
    thread2 = Thread(target=increase, args=(lock,))  # "Thread()" function wants "args=" in the form of a tuple

    # Start the threads
    thread1.start()
    thread2.start()

    # Join
    # Wait until all threads are finished while blocking the main thread
    thread1.join()
    thread2.join()

    # Print results from the threads
    # Expected value is 2 because 2 threads were created with the "increase()" function above avoiding race conditions
    print('End value', database_value)
    print('End main')
