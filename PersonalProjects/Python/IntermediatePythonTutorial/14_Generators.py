# Generators - Giving you more control over the iterations in a loop
import sys


# Create a generator within a function - Basically the yield statements enable control of the iterations
def mygen():
    yield 1
    yield 3  # Generators are in the order you define
    yield 2


# Create generator object
g = mygen()

# Run through iteration one at a time
value = next(g)  # One way of iterating
print(value)
print(next(g))   # Another way of iterating - Takes one line
# Run through iterations all at once
for i in g:
    print(i)

# StopIteration will occur when past iteration
g = mygen()  # Redefine the generator object because all iterations occurred
# More things that can be done with the iterations - Have to redefine object everytime tho
print(sum(g))     # Sum up the iterations
g = mygen()
print(sorted(g))  # Sort the iteration


# Here is a better example of actually using a generator
def countdown(iterator):  # The argument will be the count number or number of iterations
    print("Starting")
    while iterator > 0:   # Keep generating if iterator still greater than zero
        yield iterator    # The generator statement
        iterator -= 1     # Decrement counter


# Create object using the function
cd = countdown(4)  # The counter will be at 4
value = next(cd)   # Iterate
print(value)       # Print iterator status
print(next(cd))    # Iterate and print iterator status - Better way of printing and iterating on the same line


# Using a list as the iterator - Don't use, just for visualizing the memory difference between generators and lists
def firstn(n):
    nums = []
    num = 0
    while num < n:
        nums.append(num)
        num += 1
    return nums


# A list takes more space than a generator when it comes to iteration
# Using a generator as the iterator
def firstn_gen(n):
    num = 0
    while num < n:
        yield num
        num += 1


# First printing the use of a list as the iterator
print(sum(firstn(1000)))
print(sys.getsizeof(firstn(1000)))
# Then printing the use of generators as the iterator
print(sum(firstn_gen(1000)))
print(sys.getsizeof(firstn_gen(1000)))


# Extra practice - Using a generator to iterate through the Fibonacci sequence
def fibonacci(limit):    # A parameter giving the upper limit the sequence must not pass in value
    a, b = 0, 1
    while a < limit:
        yield a          # Generator statement
        a, b = b, a + b  # Fibonacci sequence algorithm


# Create the object for the function
fib = fibonacci(30)  # The upper limit will be 30, so the sequence will stop before hitting 30
# Iterate through whole sequence up to the limit passed in the function in the line above
for i in fib:
    print(i)

# Another way of creating a generator that can be very useful in iteration
mygen = (i for i in range(10) if i % 2 == 0)
# The three best ways of iterating
print(next(mygen))  # Using the next function to iterate one at a time
print(list(mygen))  # Print a list of iterators for easy visualization
mygen = (i for i in range(10) if i % 2 == 0)
for i in mygen:     # Iterate with a 'for loop'
    print(i)
print(f'This is the size of the memory used by the generator: {sys.getsizeof(mygen)}')

# The same thing as the above but using a list instead - Takes more space in memory!!
mylist = [i for i in range(10) if i % 2 == 0]
print(mylist)
print(f'This is the size of the memory used by the list: {sys.getsizeof(mylist)}')
