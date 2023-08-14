#!/bin/bash

YELLOW='\033[1;33m'
ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

source ascii_table.sh


# --- Functions ---

welcome_msg(){
    echo -e "${YELLOW}"
    figlet "RunnSSH"
    echo -e "${NO_COLOR}"
    echo -e "Welcome to ${YELLOW}RunSSH${NO_COLOR} please select the host you want to access\n"
}

err_msg(){
    echo -e "${ERROR_COLOR}$1${NO_COLOR}"
} 

succ_msg(){
    echo -e "${SUCCESS_COLOR}$1${NO_COLOR}"
} 

create_array(){
    local -a tmp_array=()
    if [[ "$2" == "Host" ]]
    then 
        tmp_array=$(grep -w "^Host" $1 | cut -d " " -f2)
    elif [[ "$2" == "Hostname" ]]
    then
        tmp_array=$(grep -w Hostname $1 | cut -d " " -f3)
    fi

    echo ${tmp_array[@]}
}

largest_string(){
    local len=0
    for n in $@
    do
        if [ $len -lt ${#n} ]
        then
            len=${#n}
        fi
    done
    echo $len
}

install_figma(){
    os_release="/etc/os-release"
    insystem=$(which figlet)
    echo $insystem | grep -o "no figlet"
    #sudo dnf install figlet

}

# --- START SCRIPT ---

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

read -t 3 -p "Host Number OR Menu Letter: " answ

if [ -z "$answ" ]
then
    err_msg "No option selected. Exiting"
else
    if [ $answ -gt $c ]
    then 
        err_msg "Option seleted: ${answ}, not valid. Exiting"
    else
        gnome-terminal -- bash -c "echo ${hostArray[$answ]} && ssh -vv ${hostArray[$answ]} && exec bash"
    fi
fi
