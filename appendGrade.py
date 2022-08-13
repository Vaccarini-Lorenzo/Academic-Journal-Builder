import sys

courseName = sys.argv[1]
grade = sys.argv[2]
repo = sys.argv[3]

# Setting the stats file as stdout
# From now on every print will write on the stats file
sys.stdout = open("mainFile.md", 'a')

# Last 4 chars
gitSuffix = repo[-4:]
if gitSuffix == ".git":
    # Remove suffix
    repo = repo[:-4]
repo = repo + "/blob/master/" + courseName + "Stats.md"

if len(sys.argv) == 5:
    print("external link")

print(courseName + " | " + grade + " | [stats](" + repo +")|" )
