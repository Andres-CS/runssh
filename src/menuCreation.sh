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

##
# Populate associative array with file paths
# Parameters:
#   [Array] links - array pass by reference to be populated
#   * - n number of paths to be placed in array
# return:
##
function linkPathMenu(){
    declare -n links="$1"
    # Array slicing {@:start:end} -> start from 2, we do not want the 1st 2 args.
    local -a letters=($(__getMenuLetters ${@:2:$#}))
    numArgs=$(($#))
    for ((c=0; c <= $numArgs; c++))
    do
        currLetter=${letters[$c]}
        # Add 2 to the offset the pos args, we do not want the 1st 2 args.
        offset=$((c+2))
        currValue=${!offset}
        links["$currLetter"]="$currValue"
    done
}

