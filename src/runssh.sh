#!/bin/bash

# ----------- DECLARE DEPENDENCIES -----------

Dependencies=( \
            "../.env" \
            "menuCreation.sh" \
            "messages.sh" \
            "clientConfig.sh" \
            "ascii_table.sh" \
            "sshParser.sh" \
            "colors" \
        )

# ----------- SOLVE FILE DEPENDENCY -----------

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASE_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# -----------

for file in ${Dependencies[@]}
do
    file=$BASE_DIR"/"$file
    if [ ! -f $file ]
    then
        err_msg "The below file cannot be found: \n $file"
        exit 1
    fi
    source $file
done

# ----------- START SCRIPT -----------

YELLOW='\033[1;33m'
ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[0m'
IYellow='\033[0;93m'


# --- Functions ---



# --- START SCRIPT ---

initClientConf $runssh_conf

# --- CHECK CONFIG --- 

#Get Current user
active_user=$(echo $USER)

#Predefine .SSH folder path
target_path="/home/${active_user}/.ssh/config"

# --- ACQUIRE HOSTS --- 

#Test predefine SSH folder path
#If bad, ask for a new path
if ! [ -f $target_path ]
then
    while [ ! -f $target_path ]
    do
        err_msg "** Error - Path: ${target_path} - NOT VALID."
        echo -n "** Enter a new Path: "
        read target_path
    done
    succ_msg "** Success - Path: ${target_path} - VALID"
fi

# --- STORE HOSTS IN ARRAY
declare -a hostArray=()
declare -a hostnameArray=()
declare -a menued_hostArray=()

for n in $(create_array $target_path "Host")
do
    hostArray+=($n)
done

for m in $(create_array $target_path "Hostname")
do 
    hostnameArray+=($m)
done

# --- USER UI --- 

welcome_msg

headers=$(getAllNameValues)
filePath=$(getAllPathValues)

declare -rA lpaht=$(linkPathManeu ${filePath[@]})

assembleTableHeaderBody $headers
displayTableHeader

if [ ${#hostArray[@]} == ${#hostnameArray[@]} ]
then
    # Menu Items
    postFix="@"
    maxlen=`largest_string ${hostArray[@]}`

    c=0
    for ((c=0; c<${#hostArray[@]}; c++))
    do 
        # Create var 'ws' with x number of whitespaces
        # Truncate up to largest word 'maxlen'
        # Print enclosed with quotes for it to show the whitespaces
        printf -v ws %20s
        hostArray[$c]=${hostArray[$c]}$ws
        hostArray[$c]=${hostArray[$c]:0:$maxlen}
        succ_msg "$c - ${hostArray[$c]}  ${postFix}  ${hostnameArray[$c]}"
    done
else
    count=0
    for i in ${hostArray[@]}
    do 
        succ_msg "$count - $i"
        count=$(($count + 1))
    done
    count=0
    for j in ${hostnameArray[@]}
    do 
        succ_msg "$count - $j"
        count=$(($count + 1))
    done

fi

read -t 3 -p "Host Number OR Menu Letter [q to quit]: " answ

if [ -z "$answ" ]
then
    err_msg "No option selected. Exiting"
else
    #Check if user input is not number
    if [ $((answ)) != $answ ]
    then
        if [ $answ == 'q' ]
        then
            warning_msg "Exiting runSSH"
            exit 0
        fi
        # echo ${!lpaht[@]}
        # echo ${links["a"]}

        warning_msg "You inputed letter: '${answ}'" 
        warning_msg "Which could be an option in a new feature being implemented."
        warning_msg "However said feautre is not complete yet."
        warning_msg "--------"
        warning_msg "IF this was not the desire action, please rerun 'runssh' and select the host using a digit as your input"
    else
        if [ $answ -gt $c ]
        then 
            err_msg "Option seleted: ${answ}, not valid. Exiting"
        else
            gnome-terminal -- bash -c "echo ${hostArray[$answ]} && ssh -vv ${hostArray[$answ]} && exec bash"
        fi
    fi 
fi
