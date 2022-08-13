#!/bin/bash

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt
BIN=/usr/local/bin

mv $BIN/journal.sh $PWD & mv $BIN/aJournalHeader.sh $PWD & mv $CONFIG_FOLDER/initContent.py $PWD & mv $CONFIG_FOLDER/computeStats.py $PWD & mv $CONFIG_FOLDER/printStats.py $PWD & mv $CONFIG_FOLDER/appendGrade.py $PWD & rm -r $CONFIG_FOLDER
