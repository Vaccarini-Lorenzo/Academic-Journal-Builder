#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
FOLDER_PRESENT=0
CONFIG_PRESENT=0
PERSON_CODE="nil"
REPO="nil"
COURSE="nil"
GRADES_PATH="nil"
MY_GRADE="nil"

# Args
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# g: Grade
while getopts r:c:a:p:g flag
do
    case "${flag}" in
        r) REPO=${OPTARG};;
        c) PERSON_CODE=${OPTARG};;
        a) COURSE=${OPTARG};;
        p) GRADES_PATH=${OPTARG};;
        g) MY_GRADE=${OPTARG};;
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
        done
        break;
    fi
done


# Updates PERSON_CODE and REPO if a config file is found.
# Creates one otherwise.
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
else
    mkdir $CONFIG_FOLDER
    touch $CONFIG_FILE
fi

# Updating config file
printf "$PERSON_CODE\n$REPO\n" > $CONFIG_FILE

#
if [[ $GRADES_PATH != "nil" ]] && [[ $COURSE != "nil" ]] && [[ $REPO != "nil" ]]; then
    cd $HOME
    rm -r .academicJ_tmp
    mkdir .academicJ_tmp
    cd .academicJ_tmp
fi
