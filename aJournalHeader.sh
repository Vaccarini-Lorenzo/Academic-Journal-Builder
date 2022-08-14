#!/bin/bash

ARGUMENT_LIST=(
  "repo"
  "code"
  "path"
  "add"
  "help"
)

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt

CONTENT_FOLDER=$CONFIG_FOLDER/content
CONTENT_MAIN=$CONTENT_FOLDER/README.md

PRINT_STATS=$CONFIG_FOLDER/printStats.py
APPEND_GRADE=$CONFIG_FOLDER/appendGrade.py
INIT_CONTENT=$CONFIG_FOLDER/initContent.py

FOLDER_PRESENT=0
CONFIG_PRESENT=0
CONTENT_PRESENT=0
REMOTE_ORIGIN_PRESENT=0

REMOTE_ORIGIN_CONFIG=$CONTENT_FOLDER/.git/config
REMOTE_ORIGIN_REGEX="url = .*.git"

PERSON_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"

printHelp(){
    printf "\n\n"
    printf "        Hello there! This tool is pretty simple: once installed you need to specify your person code (8 \n"
    printf "        ciphers PoliMI ID) and your repository through the flags '-c' or '--code' and '-r' or '--repo'\n"
    printf "        example:\n"
    printf "                   journal.sh -c 1065**** -r 'https://github.com/Vaccarini-Lorenzo/academicJournal.git'\n"
    printf "                                                    or\n"
    printf "                 journal.sh --code 1065**** --repo 'https://github.com/Vaccarini-Lorenzo/academicJournal.git'\n\n"

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
    printf "        If you want to remove a grade from your github page just use the '--remove-grade' flag\n"
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
        if [[ $N == 0 ]] && [[ $PERSON_CODE == "nil" ]]; then
            PERSON_CODE=$line;
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
    echo "git init..."
    cd $CONTENT_FOLDER && git init
}

# Build the config folder
buildConfigFolder(){
    echo "build the whole config folder..."
    mkdir $CONFIG_FOLDER
    mkdir $CONTENT_FOLDER
    touch $CONFIG_FILE
    touch $CONTENT_MAIN
    cd $CONTENT_FOLDER && git init
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
        echo "remote origin not found: origin added..."
        cd $CONTENT_FOLDER && git remote add origin $REPO
        git remote -v
        printf "\n\n"
    fi
}

buildNewStatsFile(){
    echo "creating the new stats file..."
    python3 $PRINT_STATS "$COURSE" $GRADES_PATH $PERSON_CODE #> $MY_GRADE
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewGrade(){
    echo "append the new grade..."
    python3 $APPEND_GRADE "$COURSE" 30 $REPO
}

pullFromGithub(){
    echo "pulling from github..."
    cd $CONTENT_FOLDER &&git pull origin master
}

pushToGithub(){
    echo "pushing to github..."
    cd $CONTENT_FOLDER && git add . && git commit -m "new grade: $COURSE" && git push origin master
}

forceReset(){
    echo "forcing reset..."
    cd $CONTENT_FOLDER && rm -r .git | cd $CONTENT_FOLDER && rm *
    git init && addRemoteOrigin && pullFromGithub
}
