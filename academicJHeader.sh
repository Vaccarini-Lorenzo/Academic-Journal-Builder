#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
CONTENT_FOLDER=$CONFIG_FOLDER/content
CONTENT_MAIN=$CONTENT_FOLDER/main.md
PRINT_STATS=printStats.py
FOLDER_PRESENT=0
CONFIG_PRESENT=0
CONTENT_PRESENT=0
PERSON_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"

# Looking for academicJ folder & config file
checkEnvironment(){
    #echo "checkEnvironment"
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
    mkdir $CONTENT_FOLDER
    if [[ $REPO != "nil" ]]; then
        echo "Initing git"
        git init
        git remote add origin $REPO
        rm .DStore
        git pull origin master
    else
        touch $CONTENT_MAIN
        python3 initContent.py
    fi
}

# Build the config folder
buildConfigFolder(){
    mkdir $CONFIG_FOLDER
    mkdir $CONTENT_FOLDER
    touch $CONFIG_FILE
    touch $CONTENT_MAIN
    python3 initContent.py
}

buildNewStatsFile(){
    touch $CONTENT_FOLDER/$COURSE.md && python3 $PRINT_STATS $COURSE $GRADES_PATH $PERSON_CODE > $MY_GRADE
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewGrade(){
    python3 appendGrade.py $COURSE $MY_GRADE $REPO
}
