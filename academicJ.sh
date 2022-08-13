#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
CONTENT_FOLDER=$CONFIG_FOLDER/content
TABLE_BUILDER=tableBuilder.py
FOLDER_PRESENT=0
CONFIG_PRESENT=0
CONTENT_PRESENT=0
PERSON_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"

# Args --- The order matters!
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# g: Grade
while getopts r:c:a:g:p: flag
do
    case "${flag}" in
        r) REPO=${OPTARG};;
        c) PERSON_CODE=${OPTARG};;
        a) COURSE=${OPTARG};;
        g) MY_GRADE=${OPTARG};;
        p) GRADES_PATH=${OPTARG};;
    esac
done

# Looking for academicJ folder & config file
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

# If the config file is present PERSON_CODE and REPO are stored.
# Otherwise a empty config file gets created.
if [[ $CONFIG_PRESENT == 1 ]]; then
    cd $CONFIG_FOLDER
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

elif [[ $FOLDER_PRESENT == 1 ]] && [[ $CONFIG_PRESENT == 0 ]]; then
    touch $CONFIG_FILE
fi


# If the content folder is not present for some reason, it gets created.
# If a repo has been already provided, it tries to pull the present work
# In case nothing is present (likely after first installation), the whole environment gets created.

#           MUST BE TESTED

if [[ $FOLDER_PRESENT == 1 ]] && [[ $CONTENT_PRESENT == 0 ]]; then
    mkdir $CONTENT_FOLDER
    if [[ $REPO != "nil" ]]; then
        git init
        rm .DStore
        git pull $REPO
    fi
elif [[ $FOLDER_PRESENT == 0 ]]; then
    mkdir $CONFIG_FOLDER
    mkdir $CONTENT_FOLDER
    touch $CONFIG_FILE
fi


# Updating config file
printf "$PERSON_CODE\n$REPO\n" > $CONFIG_FILE

if [[ $GRADES_PATH != "nil" ]] && [[ $COURSE != "nil" ]] && [[ $REPO != "nil" ]]; then
    #python3 $CONFIG_FOLDER/$TABLE_BUILDER
    touch $CONFIG_FOLDER/$(COURSE).md
    python3 $TABLE_BUILDER
fi
