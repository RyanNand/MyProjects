friends = ["Joe", "Pete", "Allen", "Jake", "Timmy", "Sue"]
print(friends[2])
print(friends[3:])
print(friends[1:4])               # "From index 1 all the way to but not including index 4"
friends[5] = "Sam"
print(friends)

friends2 = friends.copy()         # Copy list into friends2
friends.extend(friends2)          # Concatenate friends2 at the end of friends
print(friends)                    # Doesn't print correctly inside the print function

friends.append("Gregory")         # Insert "Gregory" at the end of the list
print(friends)                    # Doesn't print correctly inside the print function

friends.sort()                    # Sorts in alphabetical order, for numbers it's ascending order
print(friends)                    # Doesn't print correctly inside the print function

friends.insert(3, "Sam")          # Insert "Sam" at index 3 of the list, does the same thing as line 5 above
print(friends)                    # Doesn't print correctly inside the print function
print(friends.count("Sam"))       # How many "Sam" values are there?

friends.remove("Joe")             # Remove the first "Joe" from the list
print(friends)                    # Doesn't print correctly inside the print function

friends.pop()                     # Remove the last value in the list
print(friends)                    # To see what it popped and pop it simultaneously use .pop() in the print function

friends.reverse()                 # Reverse the order of the values in the list
print(friends)                    # Doesn't print correctly inside the print function

friends.clear()                  # Clear the list
print(friends)                   # Doesn't print correctly inside the print function
