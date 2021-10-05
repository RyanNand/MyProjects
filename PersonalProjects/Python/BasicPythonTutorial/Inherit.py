from Inherit2 import FavFood

# To inherit a class and create a sub-class we must pass the parent class's name as an argument
class FavIndianFood(FavFood):

    def fried(self):  # Same function call has a function from the inherited class
        print("Favorite Indian fried food is Samosas!")

    def dish(self):
        print("Favorite Indian dish is Chicken Tikka Masala.")
