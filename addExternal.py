import sys
import os
from os.path import expanduser

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

courseName = sys.argv[1]
externalLink = sys.argv[2]

mainFileRead = open("README.md", "r")
lines = mainFileRead.readlines()
mainFileRead.close()

mainFileOverwrite = open("README.md", "w")

terminator = "\n"
for line in lines:
    splitted = line.split(" |")
    if len(splitted) > 0 and splitted[0] != courseName:
        mainFileOverwrite.write(line)
    else:
        parsedLink = "[External link](" + externalLink + ")"
        newLine = splitted[0] + " |" + splitted[1] + " |" + splitted[2] + " |" + parsedLink + " |"
        mainFileOverwrite.write(newLine)

mainFileOverwrite.close()
