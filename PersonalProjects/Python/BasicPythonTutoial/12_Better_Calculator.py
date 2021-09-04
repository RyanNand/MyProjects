num1 = float(input("Enter in first number: "))
op = input("Enter arithmetic operator: ")
num2 = float(input("Enter in second number: "))

if op == "+":
    print(num1 + num2)
elif op == "*":
    print(num1 * num2)
elif op == "-":
    print(num1 - num2)
elif op == "/":
    print(num1 / num2)
else:
    print("Error: invalid operator!")
