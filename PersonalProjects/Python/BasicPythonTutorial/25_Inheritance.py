# This file will create a class object that utilizes another inherited class
from Inherit import FavIndianFood

# A class object for a class that utilizes inheritance
# Inherited class "FavFood"
# Inheritor class "FavIndianFood"
IndianFood = FavIndianFood()

IndianFood.dish()     # A function that is not inherited
IndianFood.fried()    # A function that is inherited but redefined in the new class
IndianFood.grilled()  # A function that is inherited
