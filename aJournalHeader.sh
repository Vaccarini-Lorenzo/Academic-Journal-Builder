#!/bin/bash

ARGUMENT_LIST=(
  "repo"
  "code"
  "path"
  "add"
  "help"
  "remove"
  "course-of-study"
  "undo"
)

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt

CONTENT_FOLDER=$CONFIG_FOLDER/content
CONTENT_MAIN=$CONTENT_FOLDER/README.md

PRINT_STATS=$CONFIG_FOLDER/printStats.py
APPEND_GRADE=$CONFIG_FOLDER/appendGrade.py
INIT_CONTENT=$CONFIG_FOLDER/initContent.py
REMOVE_GRADE=$CONFIG_FOLDER/removeGrade.py

FOLDER_PRESENT=0
CONFIG_PRESENT=0
CONTENT_PRESENT=0
REMOTE_ORIGIN_PRESENT=0

REMOTE_ORIGIN_CONFIG=$CONTENT_FOLDER/.git/config
REMOTE_ORIGIN_REGEX="url = .*.git"

MATRICOLA_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"

GRADE_FILE=$CONTENT_FOLDER/grade.txt

printHelp(){

    printf "\n\n"
    printf "        Hello there! This tool is pretty simple: once installed you need to specify your matricola code\n"
    printf "        (6 ciphers PoliMI ID) and your repository through the flags '-c' or '--code' and '-r' or '--repo'\n"
    printf "        example:\n"
    printf "                   journal.sh -c ****** -r 'https://github.com/Vaccarini-Lorenzo/academicJournal.git'\n"
    printf "                                                    or\n"
    printf "                 journal.sh --code ****** --repo 'https://github.com/Vaccarini-Lorenzo/academicJournal.git'\n\n"

    printf "        Once both your person code and your repo url are saved, you can start adding grades through the flags\n"
    printf "        '-n' or '--name' and '-p' or '--path' (path to the .txt file containing all the grades)\n"
    printf "        example:\n"
    printf "                   journal.sh -n 'Advanced Computer Architecture' -p 'Users/lorenzo/Desktop/ACAGrades.txt'\n"
    printf "                                                    or\n"
    printf "                journal.sh --name 'Advanced Computer Architecture' --path 'Users/lorenzo/Desktop/ACAGrades.txt'\n\n"

    printf "        At this point, it's all done! Your files are now in your GitHub repository\n"
    printf "        To add your course of study to your Academic Journal just use the flag '--course-of-study'\n"
    printf "        example:\n"
    printf "                   journal.sh --course-of-study 'Computer Science & Engineering'\n\n"
    printf "        If you want to remove a grade from your github page just use the '--remove' flag\n"
    printf "        example:\n"
    printf "                    journal.sh --remove-grade 'Advanced Computer Architecture'\n\n"
    printf "        In case of merge conflicts, just reset your local folder through the '-f' or '--force-reset' flag.\n"
    printf "        example:\n"
    printf "                    journal.sh -f\n\n"
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
    if [[ $REMOTE_ORIGIN_PRESENT == 0 ]]; then
        echo "origin added..."
        cd $CONTENT_FOLDER && git remote add origin $REPO
        git remote -v
        printf "\n\n"
    fi
}

buildNewStatsFile(){
    echo "creating the new stats file..."
    echo "course = $COURSE, path = $GRADES_PATH, matricola = $MATRICOLA_CODE"
    python3 $PRINT_STATS "$COURSE" $GRADES_PATH $MATRICOLA_CODE; GRADE=$?
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewGrade(){
    echo "append the new grade..."
    # It's sys.exit(-1)
    if [[ $GRADE == "255" ]]; then
        GRADE="FAILED"
    elif [[ $GRADE == 31 ]]; then
        GRADE="30L"
    fi
    python3 $APPEND_GRADE "$COURSE" $GRADE $REPO
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
    echo "$1"
    cd $CONTENT_FOLDER && chmod -R +w $CONTENT_FOLDER && rm $1Stats.md
    python3 $REMOVE_GRADE $1
    pushToGithub && echo "$1 removed!"
}
