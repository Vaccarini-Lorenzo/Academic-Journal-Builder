#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
BIN=/usr/local/bin

rm -r $CONFIG_FOLDER
mv $BIN/academicJ.sh $PWD
