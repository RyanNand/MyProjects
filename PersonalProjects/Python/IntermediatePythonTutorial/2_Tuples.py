# Tuple: ordered, immutable, allows duplicate elements
# The following are ways to create tuples
mytuple = ("max",)  # Create a tuple with only one element, the comma is required. Otherwise a string is created
print(type(mytuple))                # Find out the type of the object
mytuple = ("max", 28, "Boston")     # The parentheses are optional for tuples, lists must have the brackets tho
my2Dtuple = ((1, 2, 3), (4, 5, 6))  # Can create 2D tuples that contain lists or tuples


# Tuples have the same accessing rules as lists, refer to 'lists.py' for more accessing information
print(my2Dtuple[1][0])  # Same indexing rules, same 2D accessing rules too
for i in mytuple:       # Can print each element with the for loop
    print(i)

# Can check for particular values in the same way as for lists
if "max" in mytuple:
    print("yes")
else:
    print("no")

print(len(mytuple))          # Get the length of the tuple, this can be done for lists in the same way
print(mytuple.count("max"))  # Get count of a particular value in the tuple, this can be done for lists in the same way
print(mytuple.index("max"))  # Get location of the value in the tuple, this can be done for lists in the same way

# Tuples can be converted/copied to lists and vice versa in the following way, "copy()" does not work for tuples
mylist = list(mytuple)
mytuple2 = tuple(mylist)

# Tuple slicing is exactly the same as for list slicing, refer to 'lists.py' for more explanations
tup = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
a = tup[2:5]    # Elements from index 2 to 4
print(a)
a = tup[:5]     # Elements up to index 5
print(a)
a = tup[2:]     # Elements from index 2 and onward
print(a)
a = tup[::2]    # Every other element
print(a)
a = tup[1::2]   # Every other element starting from index 1
print(a)
a = tup[1:4:2]  # Every other element starting from index 1 to index 3
print(a)
a = tup[::-1]   # An alternative to "tup.reverse()", just another way to reverse the list or tuple
print(a)

# The following is called unpacking. Works for both lists and tuples in the same way
name, age, city = mytuple  # The number of objects must match the exact number of elements in the tuple or list
print(name)
print(age)
print(city)

# A way of splitting up the elements within a tuple or list whilst assigning them to variables
mytuple = (0, 1, 2, 3, 4)
i1, *i2, i3, = mytuple  # The "*" means the "i2" variable will hold whatever is left between "i1" and "i3"
print(i1)
print(i2)
print(i3)
i1, *i2, i3, i4 = mytuple  # More variables can be added to split them up in different ways
print(i1)
print(i2)
print(i3)
print(i4)


# There are three things to consider when using tuples
# 1. Tuples are immutable - cannot be altered once created
# 2. Lists are larger in memory size than tuples especially when the elements are identical
# 3. Lists are less time efficient to create and utilize than tuples for the processor
