
import os
# Temporary chdir. This file will be in .academicJ
os.chdir("/Users/lorenzo/.academicJ")
os.chdir("content")

mainFile = open("main.md", "w")
mainFile.write("| Course | Grade | Stats | External link |\n:--- | :--- | :--- | :--- | ")
