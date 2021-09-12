# Process pool (auto process manager) - Divide the data to create parallel processes
from multiprocessing import Pool


# The function to 'do stuff'
def cube(number):  # Cube the passed number
    return number * number * number


if __name__ == "__main__":  # If in the main module

    numbers = range(10)  # Create a list from 0 to 9
    pool = Pool()        # Create the pool object

    # The pool takes care of many processing things for you
    # The basic process is: map or apply, close, and then join
    result = pool.map(cube, numbers)  # Apply the function with the list and create multiple processes
    # pool.apply(cube, numbers[0])      Do this instead if you want to run the function with one element
    pool.close()                      # Close the pool
    pool.join()                       # Wait for all processes to finish while halting the main process
    print(result)                     # Print the results
