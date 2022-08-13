#!/bin/bash

CONFIG_FOLDER=$HOME/.academicJ
CONFIG_FILE=$CONFIG_FOLDER/academicJConfing.txt
BIN=/usr/local/bin

mv $BIN/academicJ.sh $PWD & mv $BIN/academicJHeader.sh $PWD & mv $CONFIG_FOLDER/initContent.py $PWD & mv $CONFIG_FOLDER/computeStats.py $PWD & mv $CONFIG_FOLDER/printStats.py $PWD & mv $CONFIG_FOLDER/appendGrade.py $PWD & rm -r $CONFIG_FOLDER
