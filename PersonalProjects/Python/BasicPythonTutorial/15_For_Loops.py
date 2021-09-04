# The first variable in the for loop structure can be any name you want
# Ex. letters, friend, index, etc.
# Below are various ways a for loop can be structured, probably not all included
for letters in "Ryan":
    print(letters)

friends = ["Jake", "Paul", "Timothy", "Nolan"]
for friend in friends:
    print(friend)

for name in range(len(friends)):  # Same thing as the for loop right above
    print(friends[name])

for index in range(3):
    if index == 0:
        print("First index")
    else:
        print("Not first index")

for index in range(3, 12):  # Remember ranges in Python does not include the ending number
    print(index)


# A function to compute the exponent given two numbers
def expo(base, power):
    result = 1
    for iterator in range(power):
        result = result * base
    return result


print(expo(2, 3))  # Function calls for the function above
print(expo(4, 3))
