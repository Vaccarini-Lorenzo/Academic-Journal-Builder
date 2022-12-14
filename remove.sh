#!/bin/bash

CONFIG_FOLDER=$HOME/.aJournal
CONFIG_FILE=$CONFIG_FOLDER/aJournalConfig.txt
BIN=/usr/local/bin


mv $BIN/journal.sh $PWD && mv $BIN/aJournalHeader.sh $PWD
mv $CONFIG_FOLDER/initContent.py $PWD
mv $CONFIG_FOLDER/computeStats.py $PWD
mv $CONFIG_FOLDER/printStats.py $PWD
mv $CONFIG_FOLDER/appendGrade.py $PWD
mv $CONFIG_FOLDER/removeGrade.py $PWD
mv $CONFIG_FOLDER/updateAverage.py $PWD
mv $CONFIG_FOLDER/addStudyCourse.py $PWD
mv $CONFIG_FOLDER/addExternal.py $PWD
chmod -R +w $CONFIG_FOLDER && rm -r $CONFIG_FOLDER && echo "Removed!"
