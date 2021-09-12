# Strings: ordered, immutable, text representation
# Ways to create basic strings
mystring = "Hello World"
mystring8 = 'Hello World'  # Another single quote in the string will produce an error
mystring9 = """    Hello       
    World"""               # This method will print exactly as written
print(mystring9)
mystring7 = """Hello \
World"""                   # This method will disregard the newlines
print(mystring7)

# Ways of formatting and creating strings
var = "Tom"
mystring7 = "the variable is %s" % var                         # Include a string variable
print(mystring7)
var = 3
mystring7 = "the variable is %d" % var                         # Include a integer variable
print(mystring7)
var = 3.145
mystring7 = "the variable is %.2f" % var                       # Include a float variable
print(mystring7)
var2 = 4
mystring7 = "the variable is {:.1f} and {}".format(var, var2)  # Include multiple variables
print(mystring7)
# python 3 or newer
mystring7 = f"the variable is {var:.1f} and {var2*2}"          # Include variables that are easy to read and manipulate
print(mystring7)

# Accessing - same as tuples and lists, refer back to them for more information on accessing elements
char = mystring[0]
print(char)
char = mystring[-1]
print(char)
for i in mystring:
    print(i)

# Slicing - same as tuples and lists, refer back to them for more information on slicing
substring1 = mystring[1:5]   # Remember that the end index is not included
substring2 = mystring[:5]
substring3 = mystring[:]     # Another way to copy string
substring4 = mystring[::2]
substring5 = mystring[2::2]
substring6 = mystring[2:5:2]
substring = mystring[::-1]  # Another way to reverse
print(substring)

# Ways to concatenate strings
concat = mystring + substring
print(concat)

# Check the string for a particular character or substring
if 'lo' in mystring:
    print("Yes, that substring exists.")
else:
    print("No, that substring does not exist.")

# Things that can be done with strings
mystring = "             Hi Ryan!!!!!!!!!"
print(mystring)                  # Spaces will be included
print(mystring.strip())          # Remove the empty spaces
print(mystring.upper())          # Convert all characters to upper case
print(mystring.lower())          # Convert all characters to lower case
print(mystring.startswith("H"))  # Substrings work as well, will return true/false
print(mystring.endswith("H"))    # Substrings work as well, will return true/false
print(mystring.find("a"))        # Find the first match in the string and return the index, substrings work as well
print(mystring.count('an'))      # Return the number of matches in the string, substrings work as well
print(mystring.replace('Ryan', 'universe'))  # does nothing if substring not found, This function returns new string
# More things you can do with strings
mystring = "how are you doing"
mylist = mystring.split()  # Split the string into elements of a list
print(mylist)
newstring = ' '.join(mylist)  # Join elements into a string, the substring will be placed in between the elements
print(newstring)
