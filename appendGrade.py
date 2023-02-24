import sys
import os
from os.path import expanduser
import urllib.parse

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFile = open("README.md", "r")
lines = mainFile.readlines()
lastLine = lines[len(lines) - 1]
lastChar = lastLine[len(lastLine) - 1]
newLine = ""
if (lastChar != "\n"):
    newLine = "\n"

mainFile.close()

courseName = sys.argv[1]
grade = sys.argv[2]
cfu = sys.argv[3]
repo = sys.argv[4]
mainFile = open("README.md", 'a')

# Checks if a link is required or not

statsString =  "[stats]("

if len(sys.argv) == 5:
    # Last 4 chars
    gitSuffix = repo[-4:]
    gitPrefix = repo[:15]
    if gitSuffix == ".git":
        # Remove suffix
        repo = repo[:-4]
    if gitPrefix == "git@github.com:":
        repo = "https://github.com/" + repo[15:]
    escapedCourseName = urllib.parse.quote(courseName)
    repo = repo + "/blob/master/" + escapedCourseName + "Stats.md"
    statsString = statsString + repo + ")"
else:
    statsString = "None"


#if len(sys.argv) == 5:
    #print("external link")

mainFile.write(newLine + courseName + " | " + grade + " | " + cfu + " | " + statsString + " | None |\n" )
mainFile.close()
