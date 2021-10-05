# This file will create a class object that utilizes another inherited class
from Inherit import FavIndianFood

# A class object for a class that utilizes inheritance
# Parent class "FavFood"; created in "Inherit2"
# Child class "FavIndianFood"; created in "Inherit"
IndianFood = FavIndianFood()

IndianFood.dish()     # A function that was not inherited
IndianFood.fried()    # A function that was inherited but redefined in the new class
IndianFood.grilled()  # A function that was inherited
