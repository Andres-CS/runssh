#!/bin/bash

# ----------- DECLARE DEPENDENCIES -----------

Dependencies=("clientConfig.sh")

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

        msg_error "The below file cannot be found: \n $file"
        exit 1
    fi
    source $file
done

# ----------- START SCRIPT -----------

initClientConf $runssh_conf

## --- FUNCTIONS --- 

##
# Get the values from the "x_name" attribute in the config file
# Parameters:
# return: [string]
##
function getTableHeaders(){
    local -a hdrs=() 
    for pfx in $(clientConf "prefixes")
    do
        for hdr in $(clientConf "values" $pfx)
        do
            hrds+=($hdr)
            break;
        done
    done
    echo ${hrds[@]}
}

##
# Creates array with ASCII lower case letters based on number of params.
# Parameters: [string] headers
# return: [string] letters
##
function getMenuLetters(){
    local menuLetters=()
    local tmpLetter=""

    for ((i=0;i<$#;i++))
    do
        tmpLetter=$(printf "\\$(printf '%03o' "$((97 + $i))")")
        menuLetters+=($tmpLetter)
    done
    echo ${menuLetters[@]}
}

##
# Concatenaes headers into a string separated by "|" and appended by ASCII lowercase alpha letters.
# Parameters:
# return: string
##
function assembleTableHeaderBody(){
    local headerString=""
    local divider="|"
    local rawHeaders=($(getTableHeaders))
    local numHeaders=${#rawHeaders[@]}
    local menuLetters=($(getMenuLetters ${rawHeaders[@]}))

    for ((i=0; i<$numHeaders; i++))
    do
        headerString+="${divider} ${menuLetters[$i]}) ${rawHeaders[$i]} "
    done
    headerString+="${divider}"

    echo $headerString
}

##
# Based on header lenght replicate a char lenght times
# Parameters:
# return: string
##
function addBorder(){
    local str="$1"
    local lenStr=${#str}
    echo $(printf "=%.0s" {1..50})
}

##
# Displays a table header
# Parameters:
# return:
##
function displayTableHeader(){
    local hdr=$(assembleTableHeaderBody)
    addBorder "$hdr"
    echo $hdr
    addBorder "$hdr"
}

# displayTableHeader
# getMenuLetters $(getTableHeaders)