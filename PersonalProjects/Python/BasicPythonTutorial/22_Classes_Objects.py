# To import a class from another file the following format is needed below
# "from <filename> import <class name>"
from SportBook import Players

# Create the class object for utilization
player1 = Players("John Lynch", 49, "Safety", True, 47)
player2 = Players("Derrick Brooks", 48, "Linebacker", True, 55)
player3 = Players("Tom Brady", 44, "Quarterback", False, 12)

# Utilization of the class object
print(player1.num, player1.name, player1.age)
print(player2.num, player2.name, player2.age)
print(player3.num, player3.name, player3.age)
