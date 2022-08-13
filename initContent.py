
import os
# Temporary chdir. This file will be in .academicJ
os.chdir("/Users/lorenzo/.aJournal/content")

mainFile = open("README.md", "w")
mainFile.write("| Course | Grade | Stats | External link |\n:--- | :--- | :--- | :--- |\n")
