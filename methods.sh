# Args --- The order matters!
# r: Repository
# c: Person Code
# a: Add Course
# p: Grade file path
# g: Grade
read_flags(){
    while getopts r:c:a:g:p: flag
    do
        case "${flag}" in
            r) REPO=${OPTARG};;
            c) PERSON_CODE=${OPTARG};;
            a) COURSE=${OPTARG};;
            g) MY_GRADE=${OPTARG};;
            p) GRADES_PATH=${OPTARG};;
        esac
    done
}


# Looking for academicJ folder & config file
checkEnvironment(){
    for file in $HOME/.*
    do
        if [[ $file == $CONFIG_FOLDER ]]; then
            FOLDER_PRESENT=1;
            for file in $CONFIG_FOLDER/*
            do
                if [[ $file == $CONFIG_FILE ]]; then
                    CONFIG_PRESENT=1
                fi
                if [[ $file == $CONTENT_FOLDER ]]; then
                    CONTENT_PRESENT=1
                fi
            done
            break;
        fi
    done
}

# Reads the user's person code and given repo stored in a txt file
readConfigFile(){
    N=0;
    while read -r line;
    do
        if [[ $N == 0 ]] && [[ $PERSON_CODE == "nil" ]]; then
            PERSON_CODE=$line;
        elif [[ $N == 1 ]] && [[ $REPO == "nil" ]]; then
            REPO=$line;
        fi
        N=$((N+1))
    done < $CONFIG_FILE
}

# Build the content folder
buildContentFolder(){
    mkdir $CONTENT_FOLDER
    if [[ $REPO != "nil" ]]; then
        echo "Initing git"
        git init
        git remote add origin $REPO
        rm .DStore
        git pull origin master
    else
        touch $CONTENT_MAIN
        python3 initContent.py
    fi
}

# Build the config folder
buildConfigFolder(){
    mkdir $CONFIG_FOLDER
    mkdir $CONTENT_FOLDER
    touch $CONFIG_FILE
    touch $CONTENT_MAIN
    python3 initContent.py
}

# Parses the grades file, updates the main.md file and appends a stats.md file
appendNewContent(){
    touch $CONTENT_FOLDER/$COURSE.md && python3 $TABLE_BUILDER $COURSE $PERSON_CODE $
}
