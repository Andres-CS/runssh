#!/bin/bash

# ----------- DECLARE DEPENDENCIES -----------

Dependencies=("configParser.sh")

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
# Parameters: (string filename)
# return: void
##
function initClientConf(){
    if test -f $1
    then
        export RUNSSH_BARCONF="$1"
    else
        echo "ERROR - NO CONFIG FILE NOT FOUND"
        return 1
    fi
}


##
# Parameters: (string item)
# return: various
##
function clientConf(){
    case $1 in
        prefixes)
            echo $(getPrefixes $RUNSSH_BARCONF);
            ;;
        options)
            if [ $# -lt 2 ]
            then
                return 1
            fi
            echo $(getOptions $RUNSSH_BARCONF $2 )
            ;;
        attributes)
            if [ $# -lt 2 ]
            then
                return 1 
            fi
            echo $( (getAttributes $(getOptions $RUNSSH_BARCONF $2)) )
            ;;
        values)
            if [ $# -lt 2 ]
            then
                return 1
            fi
            echo $( (getValues $(getOptions $RUNSSH_BARCONF $2)) )
            ;;
        *)
            return 1
            ;;
    esac
}