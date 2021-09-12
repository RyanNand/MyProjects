# Lists: ordered, mutable, allows duplicate elements
# Ways to create a list. Lists can contain numbers, strings, and tuples
mylist = ["banana", "cherry", "apple"]
mylist2 = [2, 7, 4, 8, 6, 9, 5, 14, 22, 34]
mylist3 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]  # 2D list that can contain lists or tuples
# Accessing the elements within a list
item = mylist[0]   # Accessing elements in a 1D list, index starts at 0 to n-1 where n is the number of elements
print(item)
item = mylist[-1]  # Can index from the back of the list too, starting from -1 to -n where n is the number of elements
print(item)
item = mylist3[1][0]  # Accessing elements within lists in a list - 2D lists
print(item)

# The following is a basic way to check the list for a particular value
if "banana" in mylist:
    print("yes")
else:
    print("no")

# Copy a list into another object whilst sorting it, leaving the original as is
mylist = sorted(mylist2)
print(mylist)

# A way to insert a repeating value(s) into a list
mylist = [0, 1] * 5 # There can be any number of elements greater than zero within the brackets
print(mylist)

# You can concatenate lists
mylist = mylist + mylist2
print(mylist)

# Slicing
mylist = mylist2[1:5]  # Remember the range does not include the index on the right side of the colon, so elements 1-4
print(mylist)
mylist = mylist2[:5]   # Elements 0 to 4
print(mylist)
mylist = mylist2[3:]   # Elements from 3 and onward
print(mylist)
# The following means to insert every other third value starting from index 5
mylist = mylist2[5::3]    # Every third element from index 5 and onward
print(mylist)             # The 3 or the 'step integer' can be any value greater than or equal to 1
mylist = mylist2[5:10:3]  # The above slicing methods can be combined, every third element from index 5 to index 9
print(mylist)
mylist = mylist2[::-1]    # Another way to reverse the list
print(mylist)

# This method will alter BOTH lists!
# Make sure to copy lists either using "mylist = mylist2.copy()" or "mylist = mylist2[:]" or "mylist = list(mylist2)"
# Otherwise know that both objects will be referencing the same location in memory or list
mylist = mylist2
mylist.append(3)
print(mylist2)

# Create lists based on another list
mylist = [x*x for x in mylist2]  # In this case the list will contain squared values when compared to "mylist2" values
print(mylist)
