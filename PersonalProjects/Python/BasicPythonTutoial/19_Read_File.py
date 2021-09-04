# How to open, read, and close files

file = open("Names.txt", "r")  # "r" - read, "w" - write, "a" - append, "r+" - read/write

print(file.readable())        # Is the file readable?
print(file.read())            # Read the whole file
file.seek(0)                  # Move cursor back to top of file
print(file.readline())        # Read a line
file.seek(0)                  # Move cursor back to top of file
print(file.readlines()[0:2])  # Read a range of lines

file.seek(0)
for names in file.readlines():
    print(names)

# There are write functions equivalent to the read functions above

file.close()                  # Make sure to always close the file
