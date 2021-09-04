# 2D or multidimensional list
grid = [
    [4, 3, 2],
    [7, 8, 9],
    [6, 5, 1],
    [10]
]

print(grid[2][1])  # Access a number/string from the 2D list

# Nested for loops
for row in grid:
    for col in row:
        print(col)

