#!/bin/bash

ARGUMENT_LIST=(
  "repo"
  "code"
  "path"
  "weight"
  "add"
  "help"
  "remove"
  "course-of-study"
  "undo"
  "test"
  "external"
)

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt

CONTENT_FOLDER=$CONFIG_FOLDER/content
CONTENT_MAIN=$CONTENT_FOLDER/README.md

PRINT_STATS=$CONFIG_FOLDER/printStats.py
APPEND_GRADE=$CONFIG_FOLDER/appendGrade.py
INIT_CONTENT=$CONFIG_FOLDER/initContent.py
REMOVE_GRADE=$CONFIG_FOLDER/removeGrade.py
UPDATE_AVERAGE=$CONFIG_FOLDER/updateAverage.py
ADD_STUDY_COURSE=$CONFIG_FOLDER/addStudyCourse.py
ADD_EXTERNAL=$CONFIG_FOLDER/addExternal.py

FOLDER_PRESENT=0
CONFIG_PRESENT=0
CONTENT_PRESENT=0
REMOTE_ORIGIN_PRESENT=0
REMOTE_ORIGIN_INVALID=0

REMOTE_ORIGIN_CONFIG=$CONTENT_FOLDER/.git/config
REMOTE_ORIGIN_REGEX="url = .*.git"

MATRICOLA_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"
CFU="nil"

GRADE_FILE=$CONTENT_FOLDER/grade.txt

printHelp(){

    printf "\n\n"
    printf "     +  Intro\n"
    printf "        Hello there! This tool is pretty simple: once installed you need to specify your matricola code\n"
    printf "        (6 ciphers PoliMI ID) and your repository through the flags '-c' or '--code' and '-r' or '--repo'\n"
    printf "        example:\n"
    printf "                 journal.sh -c ****** -r 'git@github.com:Vaccarini-Lorenzo/Academic-Journal.git'\n"
    printf "                                                    or\n"
    printf "                 journal.sh --code ****** --repo 'git@github.com:Vaccarini-Lorenzo/Academic-Journal.git'\n\n\n"
    printf "     +  How to insert grades\n"
    printf "        Once both your person code and your repo url are saved, you can start adding grades through the flags\n"
    printf "        '-n' or '--name' (course name), '-p' or '--path' (path to the .txt file containing all the grades) and '-w' or\n"
    printf "        '--weight' (number of CFU)\n"
    printf "        example:\n"
    printf "             journal.sh -n 'Advanced Computer Architecture' -p 'Users/lorenzo/Desktop/ACAGrades.txt' -w '5'\n"
    printf "                                                    or\n"
    printf "             journal.sh --name 'Advanced Computer Architecture' --path 'Users/lorenzo/Desktop/ACAGrades.txt' --weight '5'\n\n"
    printf "        At this point, it's all done! Your files are now in your GitHub repository\n\n\n"
    printf "     +  How to insert grades without a grade file\n"
    printf "        If you don't have access to a file containing all the grades you can simply add your personal grade\n"
    printf "        with the flag '-g' or '--grade' (statistics won't be computed):\n"
    printf "        example:\n"
    printf "             journal.sh -n 'Advanced Computer Architecture' -g '28' -w '5'\n"
    printf "                                                    or\n"
    printf "             journal.sh --name 'Advanced Computer Architecture' --grade '28' --weight '5'\n\n\n"
    printf "     +  How to add your course of study\n"
    printf "        To add your course of study to your Academic Journal just use the flag '--course-of-study'\n"
    printf "        example:\n"
    printf "             journal.sh --course-of-study 'Computer Science & Engineering'\n\n\n"
    printf "     +  How to add an external link\n"
    printf "        To add an external link to a course, use the flag '--external'\n"
    printf "        example:\n"
    printf "             journal.sh --external 'Advanced Computer Architecture' 'https://yourlink.com'\n\n\n"
    printf "     +  How to remove a grade\n"
    printf "        If you want to remove a grade from your github page just use the '--remove' flag\n"
    printf "        example:\n"
    printf "             journal.sh --remove 'Advanced Computer Architecture'\n\n\n"
    printf "     +  How to solve conflicts or unexpected behaviours\n"
    printf "        In case of conflicts, just reset your local folder through the '-f' or '--force-reset' flag.\n"
    printf "        example:\n"
    printf "             journal.sh -f\n\n"
    printf "        ATTENTION: This way your local folder will be deleted and restored through a git pull.\n\n\n"

}

# Looking for academicJ folder & config file
checkEnvironment(){
    for file in $HOME/.*
    do
        if [[ $file == $CONFIG_FOLDER ]]; then
            FOLDER_PRESENT=1;
            for file in $CONFIG_FOLDER/*
            do
                if [[ $file == $CONFIG_FILE ]]; then
                    CONFIG_PRESENT=1
                fi
                if [[ $file == $CONTENT_FOLDER ]]; then
                    CONTENT_PRESENT=1
                fi
            done
            break;
        fi
    done
}

# Reads the user's person code and given repo stored in a txt file
readConfigFile(){
    N=0;
    while read -r line;
    do
        if [[ $N == 0 ]] && [[ $MATRICOLA_CODE == "nil" ]]; then
            MATRICOLA_CODE=$line;
        elif [[ $N == 1 ]] && [[ $REPO == "nil" ]]; then
            REPO=$line;
        fi
        N=$((N+1))
    done < $CONFIG_FILE
}

# Build the content folder
buildContentFolder(){
    echo "build the content folder..."
    mkdir $CONTENT_FOLDER
    touch $CONTENT_MAIN
    cd $CONTENT_FOLDER && git init --quiet && echo "git folder has been initializated..."
}

# Build the config folder
buildConfigFolder(){
    echo "build the whole config folder..."
    mkdir $CONFIG_FOLDER
    mkdir $CONTENT_FOLDER
    touch $CONFIG_FILE
    touch $CONTENT_MAIN
    cd $CONTENT_FOLDER && git init --quiet && echo "git folder has been initializated..."
}

addRemoteOrigin(){
    # Just in case the user messes up:
    # If $REPO is nil it wont be possible to force the reset
    readConfigFile
    while read -r line;
    do
        if [[ $line =~ $REMOTE_ORIGIN_REGEX ]]; then
            echo "remote origin found..."
            REMOTE_ORIGIN_PRESENT=1
            break;
        fi
    done < $REMOTE_ORIGIN_CONFIG
    # If origin is not preset it gets added.
    # If it's invalid (user changed repo), it gets modified
    if [[ $REMOTE_ORIGIN_PRESENT == 0 ]] || [[ $REMOTE_ORIGIN_INVALID == 1 ]]; then
        echo "origin added..."
        if [[ $REMOTE_ORIGIN_PRESENT == 1 ]]; then
            cd $CONTENT_FOLDER && git remote set-url origin $REPO
        else
            cd $CONTENT_FOLDER && git remote add origin $REPO
        fi
        cd $CONTENT_FOLDER && git remote -v
    fi
}

buildNewStatsFile(){
    echo "creating the new stats file..."
    python3 $PRINT_STATS "$COURSE" "$GRADES_PATH" $MATRICOLA_CODE; MY_GRADE=$?
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewGrade(){
    echo "append the new grade..."
    # It's sys.exit(-1)
    if [[ $MY_GRADE == "255" ]]; then
        MY_GRADE="FAILED"
    elif [[ $MY_GRADE == 31 ]]; then
        MY_GRADE="30L"
    fi
    # If a user doesn't have or doesn't want the stats link he can just insert
    # the grade. In that case, the "stats" link won't be added.
    # The 5th argument to the appendGrade.py script will be checked and if present
    # a stats link won't be attached
    if [[ $1 != "" ]]; then
        python3 $APPEND_GRADE "$COURSE" $MY_GRADE $CFU $REPO $1
    else
        python3 $APPEND_GRADE "$COURSE" $MY_GRADE $CFU $REPO
    fi
}

pullFromGithub(){
    echo "pulling from github..."
    cd $CONTENT_FOLDER && addRemoteOrigin && git pull --quiet origin master && echo "git pull: Up to date..."
}

pushToGithub(){
    echo "pushing to github..."
    cd $CONTENT_FOLDER && git add . && echo "added..." && git commit -m "new grade: $COURSE" && echo "committed..." && git push --quiet origin master && echo "pushed!"
}

forceReset(){
    echo "forcing reset..."
    cd $CONTENT_FOLDER && chmod -R +w $CONTENT_FOLDER && rm -r .*; cd $CONTENT_FOLDER && rm *
    git init --quiet && addRemoteOrigin && pullFromGithub
}

removeGrade(){
    echo "removing grade..."
    cd $CONTENT_FOLDER && chmod -R +w $CONTENT_FOLDER && rm $1Stats.md
    python3 $REMOVE_GRADE $1 && python3 $UPDATE_AVERAGE
    pushToGithub && echo "$1 removed!"
}

updateAverage(){
    python3 $UPDATE_AVERAGE
}

addCourse(){
    python3 $ADD_STUDY_COURSE
}
