# A debugging and error handling method for Python
try:
    num = int(input("Enter in a number: "))
    num = num / 0
except ValueError as err:
    print("Not an integer!")
except ZeroDivisionError as err:
    print(err)


# Don't use broad exceptions, use the value code description like above.
