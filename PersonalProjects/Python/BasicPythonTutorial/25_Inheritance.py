# This file will create a class object that utilizes another inherited class
from Inherit import FavIndianFood

# A class object for a class that utilizes inheritance
# Parent class "FavFood"       # Created in "Inherit2"
# Child class "FavIndianFood"  # Created in "Inherit"
IndianFood = FavIndianFood()

IndianFood.dish()     # A function that is not inherited
IndianFood.fried()    # A function that is inherited but redefined in the new class
IndianFood.grilled()  # A function that is inherited
