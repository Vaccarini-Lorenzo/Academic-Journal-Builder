import os
from os.path import expanduser
import sys

home = expanduser("~")

CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

mainFile = open("README.md", "w")

mainFile.write("<div align=\"center\">\n\n")
mainFile.write("# Academic Journal 📕\n\n")
mainFile.write("</div>\n\n")
mainFile.write("<div align=\"center\">\n\n")
mainFile.write("[![credits](http://img.shields.io/badge/Academic%20Journal-Builder-purple?labelColor=orange&style=for-the-badge)](https://github.com/Vaccarini-Lorenzo/Academic-Journal-Builder)\n\n")
mainFile.write("</div>\n\n")
mainFile.write("### This GitHub repository contains a list of grades received over the past months.\n\n")
mainFile.write("### Some of them have a statistic report and an external link to extra content such as projects, notes and books.\n\n")
mainFile.write("---\n\n")
mainFile.write("### Course of study:\n\n")
mainFile.write("### Current average:\n\n")
mainFile.write("---\n\n")
mainFile.write("<br>\n\n")
mainFile.write("<div align=\"center\">\n\n")
mainFile.write("| Course | Grade | CFU | Stats | External link |\n")
mainFile.write(":--- | :--- | :--- | :--- | :--- |\n")
