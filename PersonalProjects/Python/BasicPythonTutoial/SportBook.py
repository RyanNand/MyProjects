class Players:

    def __init__(self, name, age, position, hof, num):
        self.name = name
        self.age = age
        self.position = position
        self.hof = hof
        self.num = num

    def is_retired(self):
        if self.num > 45:
            print(self.name + " is retired!")
        else:
            print(self.name + " might still be playing!")
