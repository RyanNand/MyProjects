# The basics of function parameters and arguments
def print_name(name):  # The "name" is the parameter
    print(name)


print_name('Lexi')  # "Lexi" is the argument


# Types of arguments
def foo(a, b, c):
    print(a, b, c)


# Only switching from positional to key arguments is allowed
foo(1, 2, 3)        # Positional arguments
foo(c=1, b=2, a=3)  # Key arguments, position does not matter


# A function with a default parameter, must be at end of the parameters
def foo(a, b, c, d=4):
    print(a, b, c, d)


# Call the function
foo(1, 3, 5)     # Use the default
foo(1, 3, 5, 2)  # Override the default with 2


# Define a function that can take any number of arguments when called
def foo(a, b, *args, **kwargs):
    print(a, b)
    for arg in args:
        print(arg)
    for key in kwargs:
        print(key, kwargs[key])


# "*args" allows as many positional arguments
# "**kwargs" allows as many key arguments
# Here are various function call statements to illustrate the above
foo(1, 2, 3, 4, 5, six=6, seven=7)
foo(1, 2, six=6, seven=7)
foo(1, 2, 3, 4, 5)


# Limiting the type of arguments using the star operator - Any argument after the star must be key arguments
def foo(a, b, *, c, d):
    print(a, b, c, d)


foo(1, 2, c=3, d=4)  # Calling the function any other way will throw an error


# Allowing multiple positional arguments - Any argument after "*args" must be key arguments
def foo(*args, last):
    for arg in args:
        print(arg)
    print(last)


foo(1, 2, 3, last=100)  # Here we can call with multiple positional arguments but the 'last' key argument is required


# Using lists, tuples, and dictionaries as arguments to a function
def foo(a, b, c):
    print(a, b, c)


# Create and unpack the list or tuple to pass as arguments
mylist = [0, 1, 2]   # List must match the number of parameters
foo(*mylist)         # Unpack list into arguments, works with tuples as well
# Create and unpack the dictionary to pass as arguments
mydictionary = {'a': 1, 'b': 2, 'c': 3}
foo(**mydictionary)  # Unpacking a dictionary


# Using a global variable in the function
def foo():
    global number  # Create global variable, which intakes the value from the originally out-of-scope "number" variable
    x = number     # Update x with the global variable
    number = 3     # Update the global variable
    print('Number inside function:', x)  # Note how "x" does not update even though "number" as been reassigned


number = 0         # The originally out-of-scope variable, only works if both variables have the same name
foo()              # Call the function
print(number)      # Print updated global variable value


# Here is what happens if you only use a local variable, different results of course
def foo():
    number = 3  # Local variable with the same name


number = 0      # Create out-of-scope variable
foo()           # Call the function
print(number)   # The variable is still 0


# Immutable objects - Again, out-of-scope variables will not update even though passing through function
def foo(x):
    x = 5


var = 10
foo(var)    # This does not update the out-of-scope "var" variable
print(var)  # The printed value is still 10
# To fix this, we can include "return x" in the function and have "var = foo(var)" as the call


# Mutable objects - Lists are mutable objects that will return changes even when you'd think it's 'out-of-scope'
def foo(a_list):
    a_list.append(4)  # Append to the passed list object


mylist = [1, 2, 3]    # Create list
foo(mylist)           # Call function and pass list
print(mylist)         # The print shows that the list updated even in a function - Mutable object


# Be mindful when creating local variables in a function
def foo(a_list):
    a_list = [7, 8, 9]  # This creates a new local list object that differs from the passed list object
    a_list.append(4)    # Now the function will only look at the local list object


mylist = [1, 2, 3]      # Create list
foo(mylist)             # Call function and pass list
print(mylist)           # This does not work anymore, the list was not appended with 4 like before


# Just another way to append the list
def foo(a_list):
    a_list += [7, 8, 9]  # Append to the passed list object


mylist = [1, 2, 3]       # Create list
foo(mylist)              # Call function and pass list
print(mylist)            # The print shows that the list updated even in a function - Mutable object


# Back to creating a new local variable
def foo(a_list):
    a_list = a_list + [7, 8, 9]  # This creates a new local list object that differs from the passed list object


mylist = [1, 2, 3]               # Create list
foo(mylist)                      # Call function and pass list
print(mylist)                    # This does not work anymore, a new local variable within the function got in the way
