# Modules are like header files in c/c++ or packages in SystemVerilog

# Importing a module I created from earlier
import Functions
# Importing a module that was in the base installation of Python
# These modules are stored in 'External Libraries/Python 3.9/lib'
import calendar

print(Functions.cube(2))
Functions.greet_user("Ryan", 27)
print(calendar.weekday(1993, 12, 30))

# Use "pip" in the windows console to install a third-party module (python community created module)
# There usually is installation instructions for each third-party modules
# Third-party modules get stored inside 'External Libraries/Python 3.9/site-packages'
# Ex. of installing a third-party module: "pip install python-docx"
# Ex. of removing the module: "pip uninstall python-docx"
