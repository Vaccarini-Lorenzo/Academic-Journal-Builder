#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
CONTENT_FOLDER=$CONFIG_FOLDER/content
CONTENT_MAIN=$CONTENT_FOLDER/README.md
PRINT_STATS=printStats.py
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
    echo "build the content folder..."
    mkdir $CONTENT_FOLDER
    touch $CONTENT_MAIN
    python3 initContent.py
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
    python3 initContent.py
}

addRemoteOrigin(){
    while read -r line;
    do
        if [[ $line =~ $REMOTE_ORIGIN_REGEX ]]; then
            echo "remote origin found..."
            REMOTE_ORIGIN_PRESENT=1
        fi
    done < $REMOTE_ORIGIN_CONFIG
    if [[ $REMOTE_ORIGIN_PRESENT == 0 ]]; then
        echo "origin added..."
        cd $CONTENT_FOLDER && git remote add origin $REPO
    fi

}

buildNewStatsFile(){
    echo "creating the new stats file..."
    python3 $PRINT_STATS $COURSE $GRADES_PATH $PERSON_CODE > $MY_GRADE
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewGrade(){
    echo "append the new grade..."
    python3 appendGrade.py $COURSE $MY_GRADE $REPO
}

pushToGithub(){
    echo "pushing to github..."
}
