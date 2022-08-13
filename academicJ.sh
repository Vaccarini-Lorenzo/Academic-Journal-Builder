#!/bin/bash

CONFIG=$HOME/.academicJConfing.txt
FOUND=0
PERSON_CODE="nil"
REPO="nil"

#Args
while getopts r:c: flag
do
    case "${flag}" in
        r) REPO=${OPTARG};;
        c) PERSON_CODE=${OPTARG};;
    esac
done

#echo "person_code = $PERSON_CODE"
#echo "repo = $REPO"

#Looking for academicJConfing.txt file
for file in $HOME/.*
do
    if [[ $file == $CONFIG ]]; then
        FOUND=1
    fi
done


if [[ $FOUND == 1 ]]; then
    N=0;
    while read -r line;
    do
        echo "$N"
        if [[ $N == 0 ]] && [[ $PERSON_CODE == "nil" ]]; then
            PERSON_CODE=$line;
        elif [[ $N == 1 ]] && [[ $REPO == "nil" ]]; then
            REPO=$line;
        fi
        N=$((N+1))
    done < $CONFIG

else
    touch $CONFIG
fi

#echo "person_code = $PERSON_CODE"
#echo "repo = $REPO"

printf "$PERSON_CODE\n$REPO\n" > $CONFIG
