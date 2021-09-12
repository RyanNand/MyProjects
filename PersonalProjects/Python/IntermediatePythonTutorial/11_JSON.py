# Javascript object notation - Used for data exchange and heavily for web applications
import json
from json import JSONEncoder

# Create a dictionary object
person = {"name": "John", "age": 30, "city": "New York", "hasChildren": False, "titles": ["engineer", "programmer"]}
# Convert the dictionary/Python to JSON format
personJSON = json.dumps(person)
print(personJSON)
# Convert the dictionary/Python to JSON format with some formatting
personJSON = json.dumps(person, indent=4)
print(personJSON)
# Convert the dictionary/Python to JSON format with sorting
personJSON = json.dumps(person, indent=4, sort_keys=True)
print(personJSON)

# Note the difference between ".dumps" above and ".dump" below
# Dump the JSON data to a file
with open('person.json', 'w') as file:
    json.dump(person, file, indent=4)

# Decoding JSON data - Converting JSON data to Python
person = json.loads(personJSON)
print(person)
# Decoding JSON data from a file - Converting JSON data to Python
with open('person.json', 'r') as file:
    person = json.load(file)
    print(person)


# Using a custom class and converting it into JSON
class User:

    def __init__(self, name, age):
        self.name = name
        self.age = age


user = User('Max', 27)  # Create a class object


# Need a custom encoder to serialize the data
# Create a function to convert class object to dictionary which then can be serialized to JSON by ".dumps()"
def encode_user(o):
    if isinstance(o, User):  # Check if passed argument is of class type, in this case 'User'
        return {'name': o.name, 'age': o.age, o.__class__.__name__: True}
    else:                    # Else raise an exception
        raise TypeError('Object of type User is not JSON serializable.')


userJSON = json.dumps(user, default=encode_user)  # Utilize the function above to convert Python to JSON
print(userJSON)


# A second way to encode Python data to JSON, similar to the method above but using a class function
# Need to import this module "from json import JSONEncoder"
class UserEncoder(JSONEncoder):
    def default(self, o):
        if isinstance(o, User):              # Check if passed argument is of class type, in this case 'User'
            return {'name': o.name, 'age': o.age, o.__class__.__name__: True}
        return JSONEncoder.default(self, o)  # Else raise an exception


# Utilizing the class to convert Python to JSON
userJSON = json.dumps(user, cls=UserEncoder)
print(userJSON)
# A second way to print
userJSON = UserEncoder().encode(user)
print(userJSON)

# Going back to Python/dictionary
user = json.loads(userJSON)
print(user)


# Creating your own decoder - Converting JSON back to Python/dictionary
def decode_user(dct):
    if User.__name__ in dct:
        return User(name=dct['name'], age=dct['age'])
    return dct


user = json.loads(userJSON, object_hook=decode_user)
print(type(user))
print(user.name)
