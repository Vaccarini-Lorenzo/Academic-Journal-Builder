#!/bin/bash


# Importing variables & methods
. academicJHeader.sh

# Read user flags
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# g: Grade
# i: Init (used in the installation phase)
while getopts r:c:a:g:p:i: flag
    do
        case "${flag}" in
            r) REPO=${OPTARG};;
            c) PERSON_CODE=${OPTARG};;
            a) COURSE=${OPTARG};;
            g) MY_GRADE=${OPTARG};;
            p) GRADES_PATH=${OPTARG};;
            i) python3 $INIT_CONTENT
            echo "exit..."
            exit 0
            ;;
        esac
    done

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

if [[ $GRADES_PATH != "nil" ]] && [[ $COURSE != "nil" ]]; then
    if [[ $REPO == "nil" ]]; then
         printf "You need to add a remote repository first.\nTry academicJ.sh -r <your_repository_link>\n"
    else
    addRemoteOrigin
    buildNewStatsFile && appendNewGrade && pushToGithub
    fi
fi