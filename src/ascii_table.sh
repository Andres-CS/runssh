#!/bin/bash

# ----------- DECLARE DEPENDENCIES -----------

Dependencies=()

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

TableHeadersBody=""

## --- FUNCTIONS --- 

##
# Creates array with ASCII lower case letters based on number of params.
# Parameters: [string] headers
# return: [string] letters
##
function __getMenuLetters(){
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
# Concatenaes headers(parameters) into a string separated by "|" and appended by ASCII lowercase alpha letters.
# Functions set global variable "TableHeadersBody"
# Parameters:[string] headerNames
# return: void
##
function assembleTableHeaderBody(){
    local headerString=""
    local divider="|"
    local rawHeaders=($@)
    local numHeaders=${#rawHeaders[@]}
    local menuLetters=($(__getMenuLetters ${rawHeaders[@]}))

    for ((i=0; i<$numHeaders; i++))
    do
        headerString+="${divider} ${menuLetters[$i]}) ${rawHeaders[$i]} "
    done
    headerString+="${divider}"

    #Set global var
    TableHeadersBody=$headerString
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
    addBorder "$TableHeadersBody"
    echo $TableHeadersBody
    addBorder "$TableHeadersBody"
}