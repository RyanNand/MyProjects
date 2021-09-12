# Collections: counter, namedtuple, orderedDict, defaultDict, deque
from collections import Counter
from collections import namedtuple
from collections import OrderedDict
from collections import defaultdict
from collections import deque

# Using the counter module - Count the number of occurrences for a unique element
a = "aaaaaabbbbbcccc"
mycounter = Counter(a)                 # Create the counter object
print(mycounter)                       # Print the number of occurrences for each unique element in a dictionary format
print(mycounter.items())               # Print the number of occurrences for each unique element in a dictionary format
print(mycounter.keys())                # Print the keys (or unique elements) in the dictionary
print(mycounter.values())              # Print the values in the dictionary
print(mycounter.most_common(2))        # Give the most common as a list of tuples, the integer can be anything > 0
print(mycounter.most_common(1)[0][0])  # Access the tuple of the most common element
print(list(mycounter.elements()))      # Print each element as a list

# Using the namedtuple - Create a tuple subclass that has a name field
point = namedtuple("pointy", "x, y")  # Create a tuple named 'pointy' and the elements names are 'x' and 'y'
pt = point(1, -4)                     # Create object that references 'pointy' and fills the elements with '1' and '-4'
print(pt)
print(pt.x, pt.y)                     # How to access elements by referencing the element names

# Using  OrderDict - Remembers insertion order
# Python 3 or newer will automatically do this
ordered_dict = OrderedDict()  # Create an object
ordered_dict['d'] = 1         # Insert to the list a tuple with key 'd' and element '1'
ordered_dict['b'] = 2         # Insert to the list a tuple with key 'b' and element '2'
ordered_dict['c'] = 3         # Insert to the list a tuple with key 'c' and element '3'
ordered_dict['a'] = 4         # Insert to the list a tuple with key 'a' and element '4'
print(ordered_dict)
print(ordered_dict['d'])      # Accessing is like accessing a dictionary even though it prints as a list of tuples

# Using defaultDict - Will provide the object dictionary a default value when no valid key is present
d = defaultdict(int)  # Create an object while defining key type, valid types are float, int, and empty list
d['a'] = 1            # Insert key 'a' with element 1
d['b'] = 2            # Insert key 'b' with element 2
print(d)              # Print the dictionary
print(d['a'])         # Accessing the dictionary
print(d['b'])
print(d['c'])         # Default value of zero

# Using deque - Can be used to manipulate both sides of a list
d = deque()              # Create object
d.append(1)              # Insert 1 from the right
d.append(2)              # Insert 2 from the right
print(d)
d.appendleft(3)          # Insert 3 from the left
print(d)
d.pop()                  # Remove the first element from the right
print(d)
d.popleft()              # Remove the first element from the left
print(d)
d.clear()                # Clear the whole list
print(d)
d.extend([4, 5, 6])      # Insert the element from the right
print(d)
d.extendleft([1, 2, 3])  # Insert the elements from the left
print(d)
d.rotate(1)              # Rotate around the first element from the right, can use any integer greater than zero
print(d)                 # Can rotate left with negative numbers
