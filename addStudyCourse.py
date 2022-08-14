import os
from os.path import expanduser
import sys

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

degree = sys.argv[1]

mainFile = open("README.md", "r")
lines = mainFile.readlines()
mainFile.close()

mainFileOverwrite = open("README.md", "w")

for line in lines:
    if line[:19] != "### Course of study":
        mainFileOverwrite.write(line)
    else:
        newLine = "### Course of study: " + degree + "\n"
        mainFileOverwrite.write(newLine)

mainFileOverwrite.close()
