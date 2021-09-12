# Multithreading examples with queue
from threading import Thread, Lock, current_thread
from queue import Queue
# import time


# Function for "target=" in the "Thread()" function below
# The function to 'do stuff' in multiple threads
def worker(q, lock):
    while True:
        value = q.get()  # Gets blocked here when there are no items in q, q.put below puts items in

        # Processing
        with lock:
            print(f'in {current_thread().name} got {value}')
        q.task_done()


if __name__ == "__main__":  # If in the main module
    q = Queue()       # Create queue object
    lock = Lock()     # Create lock object
    num_threads = 10  # Number of threads you want

    # Create threads
    for i in range(num_threads):  # Iterate through the amount of threads you want
        # Create thread objects using function and arguments
        thread = Thread(target=worker, args=(q, lock))  # Arguments are "q" and "lock" in the form of a tuple
        # The daemon thread dies after the main thread dies. This thread starts the worker function
        thread.daemon = True  # This breaks the infinite 'while loop' in worker
        # Start the thread you just created
        thread.start()

    # Insert elements into the queue
    for i in range(1, 21):
        q.put(i)  # Will insert values 1 through 20 for each element

    # Join
    # Wait until all threads are finished while blocking the main thread
    q.join()

    print('end main')
