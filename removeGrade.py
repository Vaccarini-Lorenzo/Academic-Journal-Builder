import sys
import os
from os.path import expanduser

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFileRead = open("README.md", "r")
lines = mainFileRead.readlines()
mainFileRead.close()

mainFileOverwrite = open("README.md", "w")
#sys.stdout = mainFileOverwrite

terminator = "\n"
for line in lines:
    words = line.split(" ")
    # First line of the table
    if words[0] == "|":
        terminator = ""
    if words[0] != sys.argv[1] and line != "\n":
        mainFileOverwrite.write(line + terminator)

mainFileOverwrite.close()
