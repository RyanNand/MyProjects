num1 = input("\nEnter a number: ")
num2 = input("Enter another number: ")  # By default input from user is converted to string
result = float(num1) + float(num2)  # So a function to convert them into usable numbers is needed - float()
print("The result is " + str(result) + ".\n")
