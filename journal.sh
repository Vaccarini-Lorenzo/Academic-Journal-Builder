#!/bin/bash


# Importing variables & methods
. aJournalHeader.sh

# Read user flags
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# i: Init (used in the installation phase)
while getopts :-:r:c:n:g:p:ihf flag
    do
        case "${flag}" in
            # Long flags
            -)
            case "${OPTARG}" in
                repo) REPO="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                code) PERSON_CODE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                name) COURSE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                grade) MY_GRADE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                path) GRADES_PATH="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                help)
                    printHelp
                    exit 0;
                    ;;
                force-reset)
                    forceReset
                    exit 0;
                    ;;
                remove-grade) echo "todo: remove instance";;
                course-of-study) echo "todo: course of study"

            esac;;
            # Short flags
            r) REPO=${OPTARG};;
            c) PERSON_CODE=${OPTARG};;
            n) COURSE=${OPTARG};;
            g) MY_GRADE=${OPTARG};;
            p) GRADES_PATH=${OPTARG};;
            i) python3 $INIT_CONTENT
            echo "exit..."
            exit 0
            ;;
            h) printHelp
            exit 0
            ;;
            f) forceReset
            exit 0
            ;;
            *) printHelp
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
if [[ $FOLDER_PRESENT == 1 ]] && [[ $CONTENT_PRESENT == 0 ]]; then
    buildContentFolder
elif [[ $FOLDER_PRESENT == 0 ]]; then
    buildConfigFolder
fi


# Updates config file
printf "$PERSON_CODE\n$REPO\n" > $CONFIG_FILE

# Checks if the user asked to add a grade.
# If a repo is already given a remote origin gets set and the grade gets added
if [[ $GRADES_PATH != "nil" ]] && [[ $COURSE != "nil" ]]; then
    if [[ $REPO == "nil" ]]; then
         printf "You need to add a remote repository first.\nTry academicJ.sh -r <your_repository_link>\n"
    else
    addRemoteOrigin
    pullFromGithub
    buildNewStatsFile && appendNewGrade &&pushToGithub
    fi
fi
