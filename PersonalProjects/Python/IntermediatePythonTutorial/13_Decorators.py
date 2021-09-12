# Function decorators and class decorators
# Decorators are used for many purposes such as debugging, troubleshooting, organizing, etc.
import functools


# Create a decorator - Basically a decorator is nested functions
def start_end_decorator(func):
    def wrapper():
        print('start')  # Print a start for the decorator
        func()          # The function that will 'do stuff'
        print('end')    # Print an end for the decorator
    return wrapper


# The following is how to utilize the decorator
@start_end_decorator
def print_name():
    print('Alex')


# Call the function that will 'do stuff' and the decorator will do it's thing
print_name()


# How create a decorator for a function that will have arguments passed into it
def start_end_decorator(func):
    def wrapper(*args, **kwargs):
        print('start')
        result = func(*args, **kwargs)
        print('end')
        return result
    return wrapper


# Make sure to use the decorator for the function that will 'do stuff'
@start_end_decorator
def add5(x):
    return x + 5


# Call the function that will 'do stuff' and then print the object
result = add5(10)
print(result)

# The identity of the function
print(help(add5))  # Notice the print statements mention wrapper function instead of the 'do stuff' function or 'add5'
print(add5.__name__)
print('The initial identity of the function ends here! Notice that it only mentions \'wrapper\' above.\n')


# Adding the function identity
# The full template for a function decorator
def start_end_decorator(func):
    @functools.wraps(func)  # This line will add the identity of the 'do stuff' function
    def wrapper(*args, **kwargs):
        print('start')
        result = func(*args, **kwargs)
        print('end')
        return result
    return wrapper


# Repeat the 'do stuff' function definition with the correct decorator coding
@start_end_decorator
def add5(x):
    return x + 5


# Now printing the same two statements will print the identity of the 'do stuff' function or in this case 'add5(x)'
print(help(add5))
print(add5.__name__)
print('Now the correct identity function shows up above.\n')


# Full example
def repeat(num_times):
    def decorator_repeat(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(num_times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator_repeat


@repeat(num_times=3)
def greet(name):
    print(f'Hello {name}')


greet('Alex')
# Full example ends here


# Stacking decorators - Order of the decorators matter
def start_end_decorator(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print('start')
        result = func(*args, **kwargs)
        print('end')
        return result
    return wrapper


def debug(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        args_repr = [repr(a) for a in args]
        kwargs_repr = [f"{k}={v!r}" for k, v in kwargs.items()]
        signature = ", ".join(args_repr + kwargs_repr)
        print(f"Calling {func.__name__}({signature})")
        result = func(*args, **kwargs)
        print(f"{func.__name__!r} returned {result!r}")
        return result
    return wrapper


# The two lines below define the order of the decorators
@debug                # Notice the print statements show that the order starts and finishes in the 'debug' decorator
@start_end_decorator  # When the interpreter hits line 114 it goes into the 'start_end_decorator' as a nested function
def say_hello(name):  # Afterward, when it hits line 101 it goes into 'say_hello' as a nested function, just like before
    greeting = f'Hello {name}'
    print(greeting)
    return greeting


# Call the 'do stuff' function just like before
say_hello('Ryan Nand')


# Class decorator - Does the same thing as function decorators but helpful when working with states or statuses
class CountCalls:
    def __init__(self, func):
        self.func = func
        self.num_calls = 0

    def __call__(self, *args, **kwargs):
        self.num_calls += 1
        print(f'This is executed {self.num_calls} times')
        return self.func(*args, **kwargs)


# The function that does stuff
@CountCalls
def say_hello():
    print("Hello")


# Call the function - The class decorator will store and print the number of times executed/called
say_hello()
say_hello()
