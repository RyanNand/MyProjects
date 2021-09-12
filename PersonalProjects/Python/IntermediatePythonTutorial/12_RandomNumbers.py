# Utilizing modules to implementing a random number generator for various purposes
import random       # Use for reproducible random numbers
import secrets      # Use for non-reproducible random numbers
import numpy as np  # Use for reproducible random numbers in arrays

# Create random number object
a = random.random()
print(a)
a = random.uniform(0, 10)       # Random float from 0 to 10
print(a)
a = random.randint(0, 1)        # Random integer from 0 to 1
print(a)
a = random.randrange(1, 10)     # Random integer from 0 to 9, could include a step
print(a)
a = random.normalvariate(0, 1)  # Random float with mean 0 and standard deviation of 1
print(a)
# Generating random values using elements from a list,
mylist = list("ABCDEFGH")
a = random.choice(mylist)        # Pick a random element in the list
print(a)
a = random.sample(mylist, 3)     # Pick multiple elements with no duplicates
print(a)
a = random.choices(mylist, k=3)  # Pick multiple elements with duplicates, some arguments need the key for some reason
print(a)
random.shuffle(mylist)           # Shuffle the elements of the list
print(mylist)

# The numbers are not really random, they can be reproducible
random.seed(1)
print(random.random())
print(random.randint(1, 10))
random.seed(2)
print(random.random())
print(random.randint(1, 10))
random.seed(1)
print(random.random())
print(random.randint(1, 10))
random.seed(2)
print(random.random())
print(random.randint(1, 10))

# Use "import secrets" for security or non-reproducible random numbers
a = secrets.randbelow(10)   # Generate a random integer below the value in the argument [0, n), so 10 is not included
print(a)
a = secrets.randbits(4)     # Generate a random number using n number of bits, so in this case from 4'b0000 to 4'b1111
print(a)
a = secrets.choice(mylist)  # Pick a random element in the list
print(a)

# Want an array with random floats
# Need "import numpy as np"
a = np.random.rand(3)                 # Generate a 1x3 array with random floats
print(a)
a = np.random.rand(3, 3)              # Generate a 3x3 array with random floats
print(a)
a = np.random.randint(0, 10, 3)       # Generate a 1x3 array with random integers ranging from 0 to 9
print(a)
a = np.random.randint(0, 10, (3, 4))  # Generate a 3x4 array with random integers ranging from 0 to 9
print(a)

# Create a list of values
arr = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
print(arr)
np.random.shuffle(arr)  # Generate a new list that will only shuffle elements randomly on the first axis
print(arr)

# Completely different random and seed generators when compared to the random module, but still reproducible!!!
# Must use the "np.random."
np.random.seed(1)
print(np.random.rand(2, 2))
np.random.seed(1)
print(np.random.rand(2, 2))
