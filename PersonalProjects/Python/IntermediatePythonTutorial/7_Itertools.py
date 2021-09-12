# Itertools: product, permutations, combinations, accumulate, groupby, and infinite iterators
from itertools import product
from itertools import permutations
from itertools import combinations, combinations_with_replacement
from itertools import accumulate
from itertools import groupby
from itertools import count, cycle, repeat
import operator

# Create a list from two other lists
a = [1, 2]            # Can use lists, tuples, and sets -> not recommended since sets are not ordered
b = [3, 4]
prod = product(a, b)  # Distributive product of list a with b
print(list(prod))     # Must print as a list

# Using permutations - Produce all possible ordered combinations in the form of tuples in a list
a = [1, 2, 3]              # Can use lists, tuples, and sets
perm = permutations(a)     # Produce all possible ordered combinations
print(list(perm))          # Must print as a list
perm = permutations(a, 2)  # Produce all possible ordered combinations with length of 2 elements, can use any value > 1
print(list(perm))

# Using combinations - Produce all possible combinations in the form of tuples in a list
a = [1, 2, 3]              # Can use lists, tuples, and sets
comb = combinations(a, 2)  # Produce all possible combinations with length of 2 elements, can use any value > 1
print(list(comb))          # Must print as a list
comb_wr = combinations_with_replacement(a, 2)  # Produce all possible combinations with repeatable elements of length 2
print(list(comb_wr))                           # Can use any value > 1 for length argument

# Using accumulate - Sum the previous element with the current element to produce new list of values
a = [1, 2, 5, 3, 4]                     # Can use lists, tuples, and sets -> not recommended since sets are not ordered
print(a)
acc = accumulate(a)
print(list(acc))                        # Must print as a list
acc = accumulate(a, func=operator.mul)  # Can change the summing operator to a product operator instead
print(list(acc))
acc = accumulate(a, func=max)           # Will accumulate to the largest element replacing any elements afterwards
print(list(acc))


# Using groupby - Group elements by a user defined criteria
# Create your own criteria
def smaller_than_3(x):
    return x < 3  # Return true if less than 3, false otherwise


a = [1, 2, 3, 4]
group_obj = groupby(a, key=smaller_than_3)  # Create object referencing list and criteria
for key, value in group_obj:
    print(key, list(value))  # Must use 'for loop' to iterate through results
# Another example using inline lambda function
group_obj = groupby(a, key=lambda x: x > 2)  # You can define criteria within the argument as a lambda function
for key, value in group_obj:
    print(key, list(value))
# Another example using a list of dictionaries
persons = [{"name": "Tim", "age": 25}, {"name": "Mary", "age": 30},
           {"name": "Joe", "age": 46}, {"name": "Allen", "age": 25}]
group_obj = groupby(persons, key=lambda x: x['age'])  # Group together all elements based on the 'age' key
for key, value in group_obj:
    print(key, list(value))                           # Notice how it only groups them if they are adjacent elements
group_obj = groupby(persons, key=lambda x: x['age'] > 25)  # Group together all elements based on if 'age' is > 25
for key, value in group_obj:
    print(key, list(value))                                # Note how it only groups them if they are adjacent elements

# Using infinite iterators
c = 0
for i in count(10):     # Iterate to infinity starting at count value
    print(i)
    if i == 15:         # Break infinite loop if iterator hits 15
        break
a = [1, 2, 3]
for i in cycle(a):      # Cycle through elements of list an infinite number of times
    print(i)
    if i == 2:          # Lines 74 through 77 are just to break the infinite loop
        c += 1
    if c == 5:
        break
for i in repeat(1):     # Repeat the value infinite times
    print(i)
    c += 1              # Lines 80 through 82 are just to break the infinite loop
    if c == 10:
        break
for i in repeat(1, 4):  # Repeat the value four times - A better option to the 'for loop' above
    print(i)
