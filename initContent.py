import os
from os.path import expanduser
home = expanduser("~")

CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFile = open("README.md", "w")
mainFile.write("| Course | Grade | Stats | External link |\n:--- | :--- | :--- | :--- |\n")
