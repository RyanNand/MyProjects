# Dictrionaries: Key-value pairs, unordered, mutable
# Ways of creating dictionaries
mydictionary = {"name": "Max", "age": 26, "city": "Tampa Bay"}
mydictionary2 = dict(name="Mary", age=28, city="portland")

# Possible key types
# Lists are not acceptable as keys
mydictionary3 = {3: 9, 6: 36, 9: 81}
mydictionary4 = {(8, 7): 15}

# Accessing
value = mydictionary4[(8, 7)]             # Make sure to use the actual keys to access
print(value)
value = mydictionary["name"]             # Must use the keys
print(value)
for key in mydictionary:                 # Print the keys within the dictionary
    print(key)
for key in mydictionary.keys():          # Another way to print the keys within the dictionary
    print(key)
for value in mydictionary.values():      # Print the values within the dictionary
    print(value)
for key, value in mydictionary.items():  # Print key-value pairs within the dictionary
    print(key, value)

# Inserting new key-value pairs
mydictionary["email"] = "ryan963401@outlook.com"
print(mydictionary)
mydictionary["email"] = "jake1212@outlook.com"  # Using the same key will overwrite the previous value
print(mydictionary)

# Removing key-value pairs
del mydictionary["email"]  # Remove specific key-value pair
print(mydictionary)
mydictionary.pop("age")    # Remove specific key-value pair
mydictionary.popitem()     # Removes last item
print(mydictionary)

# Ways to check a particular key in a dictionary
# Using if-else
if "name" in mydictionary:
    print(mydictionary["name"])       # If key in the dictionary, print the value
else:
    print("The key is not present!")  # Else print not present message
# Using try-except
try:
    print(mydictionary["email"])           # If key is present then print value
except KeyError as err:                    # Remember to include error value/code
    print(str(err) + " not a valid key!")  # If exception thrown, then print exception message

# Ways to copy the dictionary
# Use "mydictionary = mydictionary2.copy()" or "mydictionary = dict(mydictionary2)" to actually copy!!!
# Slicing is not applicable to dictionaries, therefore [:] will not work for copying
# The following is NOT properly copying, instead it's two variables pointing to the same memory
mydictionary = mydictionary2  # So any changes to the contents in the memory will be reflected in both objects

# Merge dictionaries
mydictionary.update(mydictionary3)
print(mydictionary)
