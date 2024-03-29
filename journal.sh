#!/bin/bash

# Importing variables & methods
. aJournalHeader.sh

# Read user flags
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# i: Init (used in the installation phase)
while getopts :-:r:c:n:g:p:w:ihf flag
    do
        case "${flag}" in
            # Long flags
            -)
            case "${OPTARG}" in
                #test) python3 $ADD_DEGREE
                #exit 0;;
                undo) cd $CONTENT_FOLDER && chmod -R +w $CONTENT_FOLDER; rm -r *; git add . & git commit -m "reset" && git push origin master;;
                repo) REPO="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 )); REMOTE_ORIGIN_INVALID=1; addRemoteOrigin;;
                code) MATRICOLA_CODE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                name) COURSE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                grade) MY_GRADE="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                weight) CFU="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                path) GRADES_PATH="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ));;
                pull) pullFromGithub;;

                help)
                    printHelp
                    exit 0 ;;

                force-reset)
                    forceReset
                    exit 0 ;;

                remove)
                    if [[ ${!OPTIND} == "" ]]; then
                        echo "You need to specify the course name!"
                    else
                        removeGrade ${!OPTIND}
                    fi
                    exit 0;;

                course-of-study)
                    if [[ ${!OPTIND} == "" ]]; then
                        echo "You need to specify your degree course!"
                    else
                        python3 $ADD_STUDY_COURSE "${!OPTIND}" && pushToGithub
                    fi
                    exit 0;;

                external)
                if [[ ${!OPTIND} == "" ]]; then
                    echo "You need to specify the course name"
                else
                    COURSE=${!OPTIND};
                    OPTIND=$(( $OPTIND + 1 ));
                fi
                if [[ ${!OPTIND} == "" ]]; then
                    echo "You need to specify the external link"
                else
                  python3 $ADD_EXTERNAL "$COURSE" "${!OPTIND}" && pushToGithub
                fi
                exit 0;;
            esac;;
            # Short flags
            r) REPO=${OPTARG};;
            c) MATRICOLA_CODE=${OPTARG};;
            n) COURSE=${OPTARG};;
            g) MY_GRADE=${OPTARG};;
            p) GRADES_PATH=${OPTARG};;
            w) CFU=${OPTARG};;
            i) python3 $INIT_CONTENT
            echo "Installed!"
            exit 0
            ;;
            h) printHelp
            exit 0
            ;;
            f) forceReset
            exit 0
            ;;
        esac
    done

if [ "$#" == 0 ]; then
    printHelp
fi

# Checks if the environment is all set.
# The following flags get set:
#   FOLDER_PRESENT
#   CONFIG_PRESENT
#   CONTENT_PRESENT
checkEnvironment

# If the config file is present MATRICOLA_CODE and REPO are stored.
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
printf "$MATRICOLA_CODE\n$REPO\n" > $CONFIG_FILE

# Checks if the user asked to add a grade.
# If a repo is already given a remote origin gets set and the grade gets added
if [[ $COURSE != "nil" ]]; then
    if [[ $REPO == "nil" ]]; then
         printf "You need to add a remote repository first.\nTry academicJ.sh -r <your_repository_link>\n"
    else
        addRemoteOrigin && pullFromGithub
        if [[ $CFU == "nil" ]]; then
            printf "You need to specify the number of CFUs. Use the flag -w or --weight\n"
        else
            if [[ $GRADES_PATH != "nil" ]]; then
                # Not in conjunction since the printStats.py returns the grade as sys.exit value
                buildNewStatsFile; appendNewGrade && updateAverage && pushToGithub
            elif [[ $MY_GRADE != 'nil' ]]; then
                appendNewGrade 'no_stats' && updateAverage && pushToGithub
            fi
        fi
    fi
fi
