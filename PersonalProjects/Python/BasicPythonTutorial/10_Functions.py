
# Below is the function where "def" and the parenthesis/colon "():" are required to define the function
def greet_user(name, age):  # There will be two passed parameters "name" and "age"
    print("Hello " + name + ", you are " + str(age) + " years old!")
    # The function definition ends when the indentation is no longer used
    # Apparently there needs to be two empty white lines after a function definition


def cube(num):
    return num * num * num
    # Code after "return" intended within a function will not execute


print("\n")
greet_user("Ryan", 27)  # These are examples on how to call the function
greet_user("Pete", 34)
print(cube(4))          # Without a "return" in the function would print a 'none' in the console
result = cube(2)
print(result)
