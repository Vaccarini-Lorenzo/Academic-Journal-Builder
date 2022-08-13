
import os
# Temporary chdir. This file will be in .academicJ
os.chdir("/Users/lorenzo/.academicJ/content")

mainFile = open("README.md", "w")
mainFile.write("| Course | Grade | Stats | External link |\n:--- | :--- | :--- | :--- |\n")
