# Lambda arguments (essentially a anonymous function): expression
from functools import reduce

# Syntax for creating a lambda function
add10 = lambda x: x + 10
print(add10(5))
mult = lambda x, y: x * y  # Can use multiple variables and different operators
print(mult(2, 2))

# Can use lambda functions as a key or argument - "sorted()" function
mylist = [(1, 2), (15, 1), (5, -1), (10, 4)]        # A list of tuples
mylist_sorted = sorted(mylist)                      # Sort based on the first element of each tuple in the list above
print(mylist)
print(mylist_sorted)
mylist_sorted = sorted(mylist, key=lambda x: x[1])  # Sort based on the second element of each tuple in the list above
print(mylist_sorted)


def sort_by_y(x):                                   # A function that does the same thing as the lambda function above
    return x[1]


mylist_sorted = sorted(mylist, key=sort_by_y)       # Can use the defined function instead of the lambda function above
print(mylist_sorted)                                # Consider pros/cons with each method - readability, program space

# Another example of using the lambda argument with the "sorted()" function
mylist_sorted = sorted(mylist, key=lambda x: x[0] + x[1])  # Sort by adding both elements of the tuple in the list
print(mylist_sorted)

# Can use lambda functions as a key or argument - "map()" function
a = [1, 2, 3, 4, 5]
b = map(lambda x: x * 2, a)  # Create a new list based on the lambda function and another list
print(list(b))

c = [x * 2 for x in a]       # Another way of doing the above without the lambda function
print(c)

# Can use lambda functions as a key or argument - "filter()" function
b = filter(lambda x: x % 2 == 0, a)  # Create a new list removing elements based on the lambda function returning false
print(list(b))

c = [x for x in a if x % 2 == 0]     # Another way of doing the same thing above but without a lambda function
print(c)

# Can use lambda functions as a key or argument - "reduce()" function
product_c = reduce(lambda x, y: x * y, c)  # Take the elements of a list and reduce based on the lambda function
print(product_c)
