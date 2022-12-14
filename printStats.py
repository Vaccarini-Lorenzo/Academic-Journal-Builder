import sys
import os
from os.path import expanduser
import computeStats

END_POINT = "https://quickchart.io/"
CHART_TYPE = "type:'bar',"
LABELS = "'17','18','19','20','21','22','23','24','25','26','27','28','29','30','30L'"
API_DATA = ""

home = expanduser("~")
CONTENT_FOLDER=home + "/.aJournal/content"
os.chdir(CONTENT_FOLDER)

# Raw formatting for possible path spaces
filePath = r"{}".format(sys.argv[2])

courseName = sys.argv[1]
gradesFile = open(filePath)
matricolaCode = sys.argv[3]

# Get num of students for each grade, average etc...
stats = computeStats.getStats(gradesFile, matricolaCode)

statsFileName = courseName + "Stats.md"

statsFile = open(statsFileName, 'w')

# Setting the stats file as stdout
# From now on every print will write on the stats file
sys.stdout = statsFile

print("# " + courseName + " Statistics\n")
print("<pre><span class=\"inner-pre\" style=\"font-size: 30px\">")

i = 17
for index, counter in enumerate(stats.counters):
    API_DATA = API_DATA + str(counter) + ","
    percentage = stats.percentages[index]
    strPercentageLen = len(percentage)
    if strPercentageLen < 6:
        percentage = percentage + "0" * (6 - strPercentageLen)
        strPercentageLen = 6
    elif strPercentageLen > 6:
        percentage = percentage[0:6]
        strPercentageLen = 6

    numSpacer = 2
    if (counter < 10):
        numSpacer = 3
    if (counter > 99):
        numSpacer = 1
    if (i == 17):
        print("\nFailed  ---> " + percentage + " %    |  " + str(counter) + numSpacer * " " + "|")
    elif (i > 30):
        print("30L     ---> " + percentage+ " %    |  " + str(counter) + numSpacer * " " + "|")
    else:
        print(i, "     ---> " + percentage + " %    |  " + str(counter) + numSpacer * " " + "|")
    i += 1

print("\nNumber of students = ", stats.numStudents)
print("\nAverage = ", stats.average, "\n")
print("Average (ignoring failed exams) = ", stats.averageIgnoringFailed, "\n")
print("Personal grade: ", stats.myGrade, end = ' ---- ')
print("Top ", stats.top , "%\n\n" )
print("</pre>")

apiString = END_POINT + "chart?c={" + CHART_TYPE + "data:{labels:[" + LABELS + "],datasets:[{label:'Number%20of%20students',data:[" + API_DATA + "]}]}}"

print("![image](" + apiString + ")")

statsFile.close()
sys.stdout = sys.__stdout__
sys.exit(stats.myGrade)
