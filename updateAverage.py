import sys
import os
from os.path import expanduser

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFile = open("README.md", "r")
lines = mainFile.readlines()
mainFile.close()

gradeSum = 0
cfuSum = 0

for line in lines:
    #if len(line)>4:
        #print(line[:19])
    tokens = line.split(" | ")
    if len(tokens) == 5 and tokens[0] != "| Course" and tokens[0] != ":---":
        grade = tokens[1]
        cfu = int(tokens[2])
        cfuSum += cfu
        if grade == "30L":
            gradeSum += 30 * cfu
        elif grade == "FAILED":
            gradeSum += 0
        elif grade == "RIMANDATO":
            gradeSum += 0
        else:
            gradeSum += int(tokens[1]) * cfu

average = round(gradeSum/(cfuSum),3)
mainFileOverwite = open("README.md", "w")
terminator = "\n"

for line in lines:
    if line[:19] != "### Current average":
        mainFileOverwite.write(line)
    else:
        newLine = "### Current average: " + str(average) + terminator
        mainFileOverwite.write(newLine)

mainFileOverwite.close()
