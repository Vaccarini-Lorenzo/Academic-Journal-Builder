import sys
import os
from os.path import expanduser

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFile = open("README.md", "r")
lines = mainFile.readlines()
mainFile.close()

sum = 0
counter = 0

for line in lines:
    #if len(line)>4:
        #print(line[:19])
    tokens = line.split(" | ")
    if len(tokens) == 4 and tokens[0] != "| Course" and tokens[0] != ":---":
        counter += 1
        grade = tokens[1]
        if grade == "30L":
            sum += 30
        elif grade == "FAILED":
            sum += 0
        elif grade == "RIMANDATO":
            sum += 0
        else:
            sum += int(tokens[1])

average = round(sum/counter,3)
print("\n\nnew average:")
print(average)

mainFileOverwite = open("README.md", "w")
terminator = "\n"

for line in lines:
    if line[:19] != "### Current average":
        mainFileOverwite.write(line)
    else:
        newLine = "### Current average: " + str(average) + terminator
        mainFileOverwite.write(newLine)

mainFileOverwite.close()
