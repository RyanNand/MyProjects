# Comparison operators: <, >, <=, >=, ==, !=
# Logical operators: and, or, not
# Ex. if (not True) or (not yes)
def max_num(num1, num2, num3):
    if num1 >= num2 and num1 >= num3:
        return num1
    elif num2 >= num1 and num2 >= num3:
        return num2
    else:
        return num3


yes = False
print(max_num(30, 501, 2))
print(not True)
print(not yes)
