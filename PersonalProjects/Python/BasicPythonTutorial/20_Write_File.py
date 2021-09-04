# We can append to existing file
file = open("Names.txt", "a")

file.write("\nLavonte David")  # Write another name after pointing the cursor to the next line

file.close()                   # Make sure to close file

# Using "w" instead of "a" will overwrite the whole file!!!
# We can create a new file and write to it using "w"

file = open("Names2.txt", "w")  # Create a new file to write to
file1 = open("Names.txt", "r")  # Open the first file for the sake of writing/copying to the created file
copy_str = file1.read()         # Read the file and store it into a variable

file.writelines(copy_str)       # Write the copied strings into the created file

file.close()                    # Close both files
file1.close()
