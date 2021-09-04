from Inherit2 import FavFood


class FavIndianFood(FavFood):

    def fried(self):  # Same function call has a function from the inherited class
        print("Favorite Indian fried food is Samosas!")

    def dish(self):
        print("Favorite Indian dish is Chicken Tikka Masala.")
