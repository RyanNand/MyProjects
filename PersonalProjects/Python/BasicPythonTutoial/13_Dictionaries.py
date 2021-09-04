# Dictionaries have the following structure
# The keys can be numbers like below or they can be strings (not shown)
# The definitions are the months in the case below
fullMonth = {
    0: "January",
    1: "February",
    2: "March",
    3: "April",
    4: "May",
    5: "June",
    6: "July",
    7: "August",
    8: "September",
    9: "October",
    10: "November",
    11: "December"
}

# Below is how to access the dictionary, use the valid keys
print(fullMonth[4])
print(fullMonth.get(12, "Not a valid key! The keys go from 0 to 11"))
