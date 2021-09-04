from Questions import QueAns  # Import class from outside file
# Create a list of questions
the_questions = [
    "Which player is in the Hall of Fame? \n(a) Derrick Brooks\n(b) Ronde Barber\n(c) Brian Kelly\n",
    "How many Superbowl's have the Tampa Bay Buccaneers won? \n(a) 7\n(b) 2 \n(c) 3\n",
    "What year did John Lynch get indicted into the HOF? \n(a) 2012\n(b) 2020\n(c) 2021\n"
]
# Create a list of class objects with the questions and correct answers
Q_A = [
    QueAns(the_questions[0], "a"),
    QueAns(the_questions[1], "b"),
    QueAns(the_questions[2], "c")
]


# Create a function that will take in the list of class objects from above
# The function will count the questions the user got correct "score"
# The function will iterate through the list of class objects prompting the user and storing their answer
# The function will compare the user's answer with the correct answer, incrementing "score" if identical
# The function will then print out the amount the user got correct
def function(q_a):
    score = 0
    for prompt in q_a:
        temp = input(prompt.que)  # Note how "prompt" points to the class object within the list of class objects
        if temp == prompt.ans:
            score += 1
    print("You got " + str(score) + " out of " + str(len(q_a)) + " correct!")


function(Q_A)  # Call the function while passing the list of class objects
