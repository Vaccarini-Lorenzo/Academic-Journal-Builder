#!/bin/bash


# Importing variables
. varHeader.sh
#I Importing methods
. methods.sh

# Read user flags
read_flags

# Checks if the environment is all set.
# The following flags get set:
#   FOLDER_PRESENT
#   CONFIG_PRESENT
#   CONTENT_PRESENT
checkEnvironment

# If the config file is present PERSON_CODE and REPO are stored.
# Otherwise a empty config file gets created.
if [[ $CONFIG_PRESENT == 1 ]]; then
    readConfigFile
elif [[ $FOLDER_PRESENT == 1 ]] && [[ $CONFIG_PRESENT == 0 ]]; then
    touch $CONFIG_FILE
fi


# If the content folder is not present for some reason, it gets created.
# If a repo has been already provided, it tries to pull the present work
# In case nothing is present (likely after first installation), the whole environment gets created.

#           MUST BE TESTED

if [[ $FOLDER_PRESENT == 1 ]] && [[ $CONTENT_PRESENT == 0 ]]; then
    buildContentFolder
elif [[ $FOLDER_PRESENT == 0 ]]; then
    buildConfigFolder
fi

# Updating config file
printf "$PERSON_CODE\n$REPO\n" > $CONFIG_FILE

if [[ $GRADES_PATH != "nil" ]] && [[ $COURSE != "nil" ]] && [[ $REPO != "nil" ]]; then
    #python3 $CONFIG_FOLDER/$TABLE_BUILDER
    computeStats && appendNewContent
fi
