#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
BIN=/usr/local/bin/

echo "$PWD"
./academicJ.sh && mv academicJ.sh $BIN && mv tableBuilder.py $CONFIG_FOLDER
