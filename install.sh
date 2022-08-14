#!/bin/bash

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt
BIN=/usr/local/bin/

./journal.sh && mv journal.sh $BIN && mv aJournalHeader.sh $BIN
mv initContent.py $CONFIG_FOLDER && journal.sh -i
mv computeStats.py $CONFIG_FOLDER
mv printStats.py $CONFIG_FOLDER
mv appendGrade.py $CONFIG_FOLDER
