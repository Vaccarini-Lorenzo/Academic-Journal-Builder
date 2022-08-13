import sys
import os

# Temporary chdir. This file will be in .academicJ
os.chdir("/Users/lorenzo/.academicJ/content")

courseName = sys.argv[1]
grade = sys.argv[2]
repo = sys.argv[3]
mainFile = open("README.md", 'a')

# Setting the stats file as stdout
# From now on every print will write on the stats file
sys.stdout = mainFile

# Last 4 chars
gitSuffix = repo[-4:]
if gitSuffix == ".git":
    # Remove suffix
    repo = repo[:-4]
repo = repo + "/blob/master/" + courseName + "Stats.md"

if len(sys.argv) == 5:
    print("external link")

print(courseName + " | " + grade + " | [stats](" + repo +")|" )
mainFile.close()
