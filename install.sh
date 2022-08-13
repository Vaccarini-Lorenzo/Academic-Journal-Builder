#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
BIN=/usr/local/bin/

echo "$PWD"
./academicJ.sh && mv academicJ.sh $BIN && mv academicJHeader $BIN
mv initContent.py $CONFIG_FOLDER
mv computeStats.py $CONFIG_FOLDER
mv printStats.py $CONFIG_FOLDER
mv appendGrade.py $CONFIG_FOLDER
