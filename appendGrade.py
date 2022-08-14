import sys
import os
from os.path import expanduser
import urllib.parse

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

courseName = sys.argv[1]
grade = sys.argv[2]
repo = sys.argv[3]
mainFile = open("README.md", 'a')

# Checks if a link is required or not

statsString =  " | [stats]("

if len(sys.argv) == 4:
    # Last 4 chars
    gitSuffix = repo[-4:]
    if gitSuffix == ".git":
        # Remove suffix
        repo = repo[:-4]
    escapedCourseName = urllib.parse.quote(courseName)
    repo = repo + "/blob/master/" + escapedCourseName + "Stats.md"
    statsString = statsString + repo + ")"
else:
    statsString = " | None"


#if len(sys.argv) == 5:
    #print("external link")

mainFile.write(courseName + " | " + grade + statsString + " | None |\n" )
mainFile.close()
