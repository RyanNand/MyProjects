# Sets: unordered, mutable, no duplicates
# Ways to create sets
myset = {1, 2, 3}
myset2 = set([1, 2, 3])
myset3 = set("hello")  # Reflected in output: order is arbitrary
print(myset3)          # Reflected in output: duplicate elements are removed
myset4 = set()         # Only way to make an empty set

# Adding elements to the set
myset4.add(10)
myset4.add(20)
myset4.add(30)
myset4.add(40)
print(myset4)

# Removing elements from the set
myset4.remove(10)   # will print error if not found
print(myset4)
myset4.discard(20)  # Same thing as remove, but won't print an error if not found
myset4.pop()        # Removes the first element in the set - NOT recommended since sets have no order
print(myset4)

# Accessing the elements, sets can not be indexed because they are unordered
for i in myset:
    print(i)

# Check for a particular value within the set
if 1 in myset:
    print("The set contains that value!")
else:
    print("The set does not contain that value!")

# Some things that can be done with sets
odds = {1, 3, 5, 7, 9}
evens = {0, 2, 4, 6, 8}
primes = {2, 3, 5, 7}
u = odds.union(evens)          # Union combines sets without duplications
print(u)
i = odds.intersection(primes)  # Intersection combines elements that are in both sets
print(i)
# Some more things that can be done with sets
set1 = {1, 2, 3, 4, 5, 6, 7, 8, 9}
set2 = {1, 2, 3, 10, 11, 12}
diff = set1.difference(set2)            # Will 'subtract' the duplicate values from set1 compared to set2
print(diff)                             # So the result should be '4, 5, 6, 7, 8, 9'
diff = set1.symmetric_difference(set2)  # Will remove the duplicates from each and then concatenate the sets
print(diff)                             # Result: '4, 5, 6, 7, 8, 9, 10, 11, 12
set1.update(set2)                       # Update set1 with the non-duplicating elements found in set2
print(set1)                             # Result: '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12' - The '10, 11, 12' was added
set1.intersection_update(set2)          # Will update set1 with elements found in both sets
print(set1)                             # Result: '1, 2, 3, 10, 11, 12' where set1 is the result from line 49 above
set1.difference_update(set2)            # Will update set1 by removing the duplicate elements
print(set1)                             # Result: empty set - since set1 and set2 have the same elements after line 51
set1.symmetric_difference_update(set2)  # Update set1 by removing duplicates from each and then concatenating the sets
print(set1)                             # Result: 1, 2, 3, 10, 11, 12 - There were no duplicates so set1 now equals set2

# Set comparisons that return boolean values - true or false
set_a = {1, 2, 3, 4, 5, 6}
set_b = {1, 2, 3}
set_c = {7, 8}
print(set_a.issubset(set_b))    # Does set_b contain set_a? Should be false
print(set_b.issubset(set_a))    # Does set_a contain set_b? Should be true
print(set_a.issuperset(set_b))  # Does set_a contain set_b? Should be true
print(set_b.issuperset(set_a))  # Does set_b contain set_a? Should be false
print(set_a.isdisjoint(set_b))  # Do the sets have different elements? Should be false
print(set_a.isdisjoint(set_c))  # Do the sets have different elements? Should be true


# Ways to copy the set
# Must use "set_b = set_a.copy" or "set_b = set(set_a)" to actually copy
# Slicing is not applicable to sets, therefore [:] will not work for copying
# The following is NOT properly copying, instead it's two variables pointing to the same memory
set_b = set_a  # So any changes to the contents in the memory will be reflected in both objects

# Create an immutable set, where difference, intersection, and union will still work
a = frozenset([1, 2, 3, 4])
print(a)
