# Python has layered copying, for example shallow may be one layered copying and deep is two layered copying
import copy

# The following is not a real copy, but a pointer to the same reference/memory
orig = [0, 1, 2, 3, 4]
cpy = orig
cpy[0] = -10
print(cpy)
print(orig)

# - Shallow copy: one level deep, only references of nested child objects
# - Deep copy: full independent copy

# Shallow copies
orig = [0, 1, 2, 3, 4]
cpy = orig.copy()  # Shallow copy
# Other things that work
# cpy = list(orig)
# cpy = orig[:]
cpy[0] = -10
print(cpy)
print(orig)        # Succeeds in not altering the original as well

# Here is where shallow copying fails - A good example is 2D lists where there are two layers
orig = [[0, 1, 2, 3, 4], [5, 6, 7, 8]]
cpy = orig.copy()  # Shallow copy
cpy[0][1] = -10    # Trying to copy an element with the 2D list
print(cpy)
print(orig)        # Failed - The original is altered as well

# Here is why we want to deep copy and how to do it
orig = [[0, 1, 2, 3, 4], [5, 6, 7, 8]]
cpy = copy.deepcopy(orig)  # Using the module copy and function ".deepcopy()", need "import copy"
cpy[0][1] = -10            # Try to alter the 2D list again
print(cpy)
print(orig)                # Succeeds - The original is not altered


# Here is another example of shallow copying
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age


p1 = Person('Alex', 27)
# p2 = p1 will not work, must use shallow copy
p2 = copy.copy(p1)  # Shallow copy
p2.age = 30         # Alter one of them
print(p2.age)
print(p1.age)       # Succeeds in not changing the other


# Here is another example where we need to use deep copying instead of shallow copying
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age


class Company:
    def __init__(self, boss, employee):
        self.boss = boss
        self.employee = employee


p1 = Person('Alex', 55)             # Create a class object
p2 = Person('Joe', 22)              # Create a class object

company = Company(p1, p2)           # Create a class object that inherits the previous class objects
company_clone = copy.copy(company)  # Shallow copy the company to the clone
# Deep copy below, shallow copy above - Comment out one of them to the result, then alternate to see the other result
#company_clone = copy.deepcopy(company)
company_clone.boss.age = 46         # Alter the age using the clone object
print(company_clone.boss.age)       # Print both the clone object's age and the original object's age
print(company.boss.age)             # Deep copying will succeed, shallow copying will fail
