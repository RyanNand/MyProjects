# Errors and exceptions

# ****** Below are some common errors ******
# SyntaxError
# a = 5 print(a)

# TypeError
# a = 5 + '10'

# ModuleNotFoundError
# import somemodulethatdoesnotexist

# NameError
# a = 5, b = c

# FileNotFoundError
# f = open('somefile')

# ValueError
# a = [1, 2, 3]
# a.remove(4)

# IndexError
# a = [1, 2, 3]
# print(a[4])

# KeyError
# mydictionary = {'name': 'max'}
# print('age')
# ****** End of common errors ******

# Ways to throw an error message
x = 1  # If negative, the error messages below will be thrown
# Exception error
if x < 0:
    raise Exception("x should be positive")  # Raise an exception error if x < 0

# Assert an error, same thing as above
assert (x >= 0), 'x is not positive'         # If x >= 0 returns false, assertion error is thrown

# If you don't know the exception
try:
    a = 5 / 0  # Do some functionality that may or may not throw some exception error
except Exception as e:
    print(e)

# If you know the exception
try:                            # Do some functionality that may or may not throw some exception error
    a = 1
    #a = 5 / 0
    #b = a + '10'
except ZeroDivisionError as e:  # Throw exception if dividing by zero
    print(e)
except TypeError as e:          # Throw exception if wrong type
    print(e)
else:                           # If not thing is wrong with the functionality
    print('Everything is fine.')
finally:  # Everything in this "finally" section will happen regardless if exception is thrown or not
    print('cleaning up...')


# Define our own exception
# Create a class defining your own exception
class ValueTooHighError(Exception):
    pass  # Pass does not do anything, equivalent to NOP


# Another example of creating a class to define your own exception
class ValueTooSmallError(Exception):
    def __init__(self, message, value):
        self.message = message  # Store the message in the message object
        self.value = value      # Store the value in the value object


# Define a function to use as the functionality that may or may not throw an exception
def test_value(x):
    if x > 100:
        raise ValueTooHighError('Value is too high')  # Can include an error message with the exception, won't be stored
    if x < 5:
        raise ValueTooSmallError('Value is too small', x)  # These arguments will be stored


try:  # Do some functionality that may or may not throw some exception error
    test_value(1)
except ValueTooHighError as e:
    print(e)                   # Only the message in the "raise()" above will be printed
except ValueTooSmallError as e:
    print(e.message, e.value)  # Can access the stored message and value
