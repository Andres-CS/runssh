#!/bin/bash

# ----------- DECLARE DEPENDENCIES -----------

Dependencies=( \
        "messages.sh" \
        "ascii_table.sh" 
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


function create_array(){
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

function largest_string(){
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

function linkPathManeu(){
    declare -A links
    local -a letters=($(__getMenuLetters ${@:1:$#}))
    tmp=$(($# - 1))
    for ((c=0; c <= $tmp; c++))
    do
        links[${letters[$c]}]=${!c}
    done

    echo ${links[@]}
}

function install_figma(){
    os_release="/etc/os-release"
    insystem=$(which figlet)
    echo $insystem | grep -o "no figlet"
    #sudo dnf install figlet

}