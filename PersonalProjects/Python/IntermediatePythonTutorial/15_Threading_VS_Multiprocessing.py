# This is a backup reference - Refer to the specific examples for a better understanding
from multiprocessing import Process
import os
import time


# Function for target=
def square_numbers():
    for i in range(100):
        i * i
        time.sleep(0.1)


processes = []
# Numer of CPUs on the machine. Usually a good choice for the number of processes
num_processes = os.cpu_count() / 2
print(int(num_processes))

# Create processes and assign a function for each process
for i in range(int(num_processes)):
    # If there are arguments p = Process(target=square_numbers, args=(tuple))
    p = Process(target=square_numbers)
    processes.append(p)

# Start all processes
for p in processes:
    p.start()

# Join
# Waiting for all processes to finish while blocking the main thread until finished
# block the main program until these processes are finsihed
for p in processes:
    p.join()

print('end main')


# ************************For threading **************************************
# from threading import Thread
# import os
# import time


# Function for target=
#def square_numbers():
#    for i in range(100):
#        i * i
#        time.sleep(0.1)


#threads = []
#num_threads = 10

# Create threads
#for i in range(num_threads):
    # If there are arguments p = Process(target=square_numbers, args=(tuple))
#    t = Thread(target=square_numbers)
#    threads.append(t)

# Start
#for t in threads:
#    t.start()

# Join
# Waiting for all threads to finish while blocking the main thread until finished
#for t in threads:
#    t.join()

#print('end main')
