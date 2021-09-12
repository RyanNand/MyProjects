# How to create context managers with classes and statements such as "with" or 'try-finally'
from threading import Lock
from contextlib import contextmanager

# Using the "with" statement to open and close a file - Basically one line of code to open/close
with open('notes.txt', 'w') as file:
    file.write('Some todo...')

# Same thing as above using 'try-finally', but takes more lines of code
file = open('notes.txt', 'w')
try:
    file.write('Some todo...')
finally:
    file.close()

# Using lock
# Need "from threading import Lock"
lock = Lock()

# Method 1 - The flow of using lock without any special statements
lock.acquire()
# Do something desirable here
lock.release()

# Method 2 - Utilizing lock with a "with" statement instead, much cleaner
#with lock:
    # Do something desirable here


# Code to create our own class to manage opening and closing a file
class ManagedFile:
    def __init__(self, filename):
        print('Init')
        self.filename = filename

    def __enter__(self):
        print("Enter")
        self.file = open(self.filename, 'w')
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.file:
            self.file.close()
        if exc_type is not None:  # This part is necessary if we would like to handle the exception ourselves
            print("Exception has been handled")
        # print('exc:', exc_type, exc_val)
        print("Exit")
        return True


# If the exception is not handled in the exit function above, the following will throw a exception
with ManagedFile('Notes.txt') as file:  # Create the class object as "file" while initializing 'Notes.txt' as filename
    print("Do some stuff...")
    file.write('Some todo...')          # Write to file, could read but would have to change "__enter__" function above
    file.somemethod()                   # This line is NOT CODE: purpose is to throw an exception
print('Continuing')                     # If the exception is not handled like above, the program will not continue


# To do the same thing as the class above but with a function
# Need "from contextlib import contextmanager"
@contextmanager  # Use the decorator
def open_managed_file(filename):
    f = open(filename, 'w')  # Create file object
    try:
        yield f              # Use a generator to be able to write multiple times or manipulate file multiple times
    finally:
        f.close()            # Make sure to close file afterwards, using 'finally' will make sure that will happen


# Then use the "with" statement to call the function passing the filename and creating "f" as the file object
# Using "with" statement and the structure of the function above will make sure to open, manipulate, and close properly
with open_managed_file('notes.txt') as f:
    f.write('Some todo...')  # Manipulate the file as you see fit
    f.write('Some to do')
