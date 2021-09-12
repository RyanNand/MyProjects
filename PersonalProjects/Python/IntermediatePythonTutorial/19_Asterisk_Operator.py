# The asterisk operator - Multiple uses: multiplication, exponents, unpacking, replicating,

# Can use it for multiplication and exponential functions
result = 5 * 7       # Multiply
print(result)
result = 2 ** 4      # Exponential function - Equivalent to 2^4
print(result)
# Can use it for replication
zeros = [0] * 10     # Ten zeros in the list
print(zeros)
zeros = [0, 1] * 10  # 0 and 1 alternating with replication 10 times
print(zeros)
zeros = (0, 1) * 10  # Same thing as above but with tuples
print(zeros)
zeros = 'AB' * 10    # Can replicate strings as well
print(zeros)


# Can use it to allow unlimited positional and key arguments
def func(a, b, *args, **kwargs):
    print(a, b)
    for arg in args:
        print(arg)
    for key in kwargs:
        print(key, kwargs[key])


# Call the function above, make sure to have the key arguments come after the positional arguments
func(1, 2, 3, 4, 5, six=6, seven=7)


# Can use it to make sure that arguments that come after asterisk parameter are key arguments
def func(a, b, *, c):
    print(a, b, c)


# Calling the function above
func(1, 2, c=3)  # Notice that c has to be a key argument as defined in the parameter list above


# Can use it to unpack arguments from a list, tuple, or dictionary
def func(a, b, c):
    print(a, b, c)


# Create list, tuple, or dictionary of arguments - The amount of elements must match the number of parameters
mylist = [0, 1, 2]    # Works with tuples as well
mydictionary = {'a': 1, 'b': 2, 'c': 3}
func(*mylist)         # The syntax to unpack lists or tuples - Only needs one asterisk operator
func(**mydictionary)  # The syntax to unpack a dictionary - Requires two asterisk operators, one will unpack the keys

# Can use the asterisk operator to unpack lists, tuples, or dictionaries (keys only for dictionaries) into other objects
numbers = (1, 2, 3, 4, 5, 6)  # Will unpack a tuple as well, but the result is a list
*beginning, last = numbers    # Will take the last element and assign it to "last", the rest goes to "beginning"
print(beginning)
print(last)
beginning, *last = numbers    # Will take the first element and assign it to "beginning, the rest goes to "last"
print(beginning)
print(last)
beginning, *middle, last = numbers  # First and last element goes to "beginning" and "last", rest goes to "middle"
print(beginning)
print(middle)
print(last)
beginning, *middle, second_last, last = numbers  # I think you get the pattern by now
print(beginning)
print(middle)
print(second_last)
print(last)

# Can unpack lists, tuples, and dictionaries whilst concatenating them to an object
mytuple = (1, 2, 3)                               # Create tuple
mylist = [4, 5, 6]                                # Create list
new_list = [*mytuple, *mylist]                    # Unpack the list and tuple above whilst concatenating them
print(new_list)
myset = {4, 5, 6}                                 # Works with sets as well
new_list = [*mytuple, *myset]                     # Unpack the tuple and set whilst concatenating them
print(new_list)
# Here is an example using dictionaries
mydictionary = {'a': 1, 'b': 2}                   # Create a dictionary
mydictionary2 = {'c': 3, 'd': 4}                  # Create another dictionary
mydictionary = {**mydictionary, **mydictionary2}  # Unpack and concatenate
print(mydictionary)
