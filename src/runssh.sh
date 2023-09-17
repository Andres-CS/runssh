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
declare -A lpath

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
filePaths=$(getAllPathValues)

linkPathMenu lpath ${filePaths[@]} 

assembleTableHeaderBody $headers
displayTableHeader

# --- PRINT HOSTS MENU ---

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

# --- PROMPT FOR USER INPUT --- 

read -t 5 -p "Host Number OR Menu Letter [q to quit]: " answ


# --- CHECK USERS RESPONSE --- 

if [ -z "$answ" ]
then
    err_msg "No option selected. Exiting"
else
    # Check if user input is not number (if it's a char)
    if [ $((answ)) != $answ ]
    then
        if [ $answ == 'q' ]
        then
            warning_msg "Exiting runSSH"
            exit 0
        fi

        # Check user's input is a KEY in the associative menu
        if [ -v "lpath[$answ]" ]
        then
            warning_msg "You have selected to see file: ${lpath[$answ]}"
            # gnome-terminal -- bash -c "nano lpath[$answ] && exec bash"
            cat ${lpath[$answ]}
        else
            warning_msg "You inputed letter: '${answ}'" 
            warning_msg "Which could be an option in a new feature being implemented."
            warning_msg "However said feautre is not complete yet."
            warning_msg "--------"
            warning_msg "IF this was not the desire action, please rerun 'runssh' and select the host using a digit as your input"
        fi

    else
        # If user input is a number
        if [ $answ -gt $c ]
        then 
            err_msg "Option seleted: ${answ}, not valid. Exiting"
        else
            # Deploy new terminal with ssh command running
            gnome-terminal -- bash -c "echo ${hostArray[$answ]} && ssh -vv ${hostArray[$answ]} && exec bash"
        fi
    fi 
fi
