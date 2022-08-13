import sys
import os
END_POINT = "https://quickchart.io/"
CHART_TYPE = "type:'bar',"
LABELS = "'17','18','19','20','21','22','23','24','25','26','27','28','29','30','30L'"


# Temporary chdir. This file will be in .academicJ
#os.chdir("/Users/lorenzo/.academicJ")
#os.chdir("content")
courseName = sys.argv[1]
gradesFile = open(sys.argv[2])
tmpFile = open("tmp.txt", "w")


# Messy implementation, just for demo
# Every grade has its own counter
counter = 0
sum = 0
failCounter = 0
eighteenCounter = 0
ninenteenCounter = 0
twentyCounter = 0
twentyOneCounter = 0
twentyTwoCounter = 0
twentyThreeCounter = 0
twentyFourCounter = 0
twentyFiveCounter = 0
twentySixCounter = 0
twentySevenCounter = 0
twentyEightCounter = 0
twentyNineCounter = 0
thirtyCounter = 0
thirtyLCounter = 0

# Writing on a tmp file in order to not modify the grades file given by the user.
for line in gradesFile.readlines():
    l = line.split("\t")
    # Check if first section is person code
    if(len(l[0]) == 6):
        terminator = "" if len(l) == 2 else "\n"
        strng = l[0] + "\t" +l[1] + terminator
        tmpFile.write(strng)

tmpFile.close()
tmpFile = open("tmp.txt")

for line in tmpFile.readlines():
    l = line.split("\t")

    if l[1] == "RIMANDATO\n":
        failCounter += 1
        sum += 16
    elif l[1] == "RIFIUTATO\n":
        counter -= 1
    elif l[1] == "30 e Lode\n":
        thirtyLCounter += 1
        sum += 32
    elif l[1] == "ASSENTE\n":
        counter -= 1
    else:
        grade = int(l[1])
        sum += grade
        if(grade == 18):
            eighteenCounter += 1
        if(grade == 19):
            ninenteenCounter += 1
        if(grade == 20):
            twentyCounter +=1
        if(grade == 21):
            twentyOneCounter +=1
        if(grade == 22):
            twentyTwoCounter +=1
        if(grade == 23):
            twentyThreeCounter +=1
        if(grade == 24):
            twentyFourCounter +=1
        if(grade == 25):
            twentyFiveCounter +=1
        if(grade == 26):
            twentySixCounter +=1
        if(grade == 27):
            twentySevenCounter +=1
        if(grade == 28):
            twentyEightCounter +=1
        if(grade == 29):
            twentyNineCounter +=1
        if(grade == 30):
            thirtyCounter +=1
    counter += 1

os.remove("tmp.txt")

counters = [failCounter,
eighteenCounter,
ninenteenCounter,
twentyCounter,
twentyOneCounter,
twentyTwoCounter,
twentyThreeCounter,
twentyFourCounter,
twentyFiveCounter,
twentySixCounter,
twentySevenCounter,
twentyEightCounter,
twentyNineCounter,
thirtyCounter,
thirtyLCounter]


statsFileName = courseName + "Stats.md"
# Setting the stats file as stdout
# From now on every print will write on the stats file
sys.stdout = open(statsFileName, 'w')

print("# " + courseName + " Statistics\n")

print("<pre><span class=\"inner-pre\" style=\"font-size: 30px\">")

data = ""

i = 17
for c in counters:
    data = data + str(c) + ","
    percentage = str(round(c/counter * 100, 3))
    strPercentageLen = len(percentage)
    if strPercentageLen < 6:
        percentage = percentage + "0" * (6 - strPercentageLen)
        strPercentageLen = 6
    elif strPercentageLen > 6:
        percentage = percentage[0:6]
        strPercentageLen = 6

    numSpacer = 2
    if (c < 10):
        numSpacer = 3
    if (c > 99):
        numSpacer = 1
    if (i == 17):
        print("\nFailed  ---> " + percentage + " %    |  " + str(c) + numSpacer * " " + "|")
    elif (i > 30):
        print("30L     ---> " + percentage+ " %    |  " + str(c) + numSpacer * " " + "|")
    else:
        print(i, "     ---> " + percentage + " %    |  " + str(c) + numSpacer * " " + "|")
    i += 1

print("\nNumber of students = ", counter)
print("\nAverage = ", round(sum/counter, 3), "\n")
print("Average (ignoring failed exams) = ", round((sum - 16 * failCounter)/(counter - failCounter), 3), "\n")

if (len(sys.argv) == 4):
    inputGrade = 0
    if(sys.argv[3] == "30L"):
        inputGrade = 31
    else:
        inputGrade = int(sys.argv[2])

    print("Personal grade: ", sys.argv[2], end = ' ---- ')
    betterThan = 0
    for i, c in enumerate(counters):
        if(i + 17 < inputGrade):
            betterThan += c

    print("Top ", round((1 - betterThan/counter) * 100, 3), "%\n\n" )
print("</pre>")

#/chart?c={type:'bar',data:{labels:[2012,2013,2014,2015,2016],datasets:[{label:'Users',data:[120,60,50,180,120]}]}}

#https://quickchart.io/chart?c={type:%27bar%27,data:{labels:[2012,2013,2014,2015,2016],datasets:[{label:%27Users%27,data:[120,60,50,180,120]}]}}
apiString = END_POINT + "chart?c={" + CHART_TYPE + "data:{labels:[" + LABELS + "],datasets:[{label:'Test',data:[" + data + "]}]}}"

print("![image](" + apiString + ")")
