import os

class stats:
    def __init__(self, counters, percentages, average, averageIgnoringFailed, numStudents):
        self.counters = counters
        self.percentages = percentages
        self.average = average
        self. averageIgnoringFailed = averageIgnoringFailed
        self.numStudents = numStudents


def getStats(gradesFile):
    tmpFile = open("tmp.txt", "w")

    # Messy implementation, just for demo
    # Every grade has its own counter
    numStudents = 0
    sum = 0
    failCounter = 0
    eighteenCounter = 0
    ninenteenCounter = 0
    twentyCounter = 0
    twentyOneCounter = 0
    twentyTwoCounter = 0
    twentyThreeCounter = 0
    twentyFourCounter = 0
    twentyFiveCounter = 0
    twentySixCounter = 0
    twentySevenCounter = 0
    twentyEightCounter = 0
    twentyNineCounter = 0
    thirtyCounter = 0
    thirtyLCounter = 0

    # Writing on a tmp file in order to not modify the grades file given by the user.
    for line in gradesFile.readlines():
        l = line.split("\t")
        # Check if first section is person code
        if(len(l[0]) == 6):
            terminator = "" if len(l) == 2 else "\n"
            strng = l[0] + "\t" +l[1] + terminator
            tmpFile.write(strng)

    tmpFile.close()
    tmpFile = open("tmp.txt")

    for line in tmpFile.readlines():
        l = line.split("\t")

        if l[1] == "RIMANDATO\n":
            failCounter += 1
            sum += 16
        elif l[1] == "RIFIUTATO\n":
            numStudents -= 1
        elif l[1] == "30 e Lode\n":
            thirtyLCounter += 1
            sum += 32
        elif l[1] == "ASSENTE\n":
            numStudents -= 1
        else:
            grade = int(l[1])
            sum += grade
            if(grade == 18):
                eighteenCounter += 1
            if(grade == 19):
                ninenteenCounter += 1
            if(grade == 20):
                twentyCounter +=1
            if(grade == 21):
                twentyOneCounter +=1
            if(grade == 22):
                twentyTwoCounter +=1
            if(grade == 23):
                twentyThreeCounter +=1
            if(grade == 24):
                twentyFourCounter +=1
            if(grade == 25):
                twentyFiveCounter +=1
            if(grade == 26):
                twentySixCounter +=1
            if(grade == 27):
                twentySevenCounter +=1
            if(grade == 28):
                twentyEightCounter +=1
            if(grade == 29):
                twentyNineCounter +=1
            if(grade == 30):
                thirtyCounter +=1
        numStudents += 1

    os.remove("tmp.txt")

    counters = [failCounter,
    eighteenCounter,
    ninenteenCounter,
    twentyCounter,
    twentyOneCounter,
    twentyTwoCounter,
    twentyThreeCounter,
    twentyFourCounter,
    twentyFiveCounter,
    twentySixCounter,
    twentySevenCounter,
    twentyEightCounter,
    twentyNineCounter,
    thirtyCounter,
    thirtyLCounter]

    percentages = []

    for counter in counters:
        percentage = str(round(counter/numStudents * 100, 3))
        percentages.append(percentage)

    average = round(sum/numStudents, 3)

    averageIgnoringFailed = round((sum - 16 * failCounter)/(numStudents - failCounter), 3)

    s = stats(counters, percentages, average, averageIgnoringFailed, numStudents)

    return s
