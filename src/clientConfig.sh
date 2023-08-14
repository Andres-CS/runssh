#!/bin/bash

source ./configParser.sh

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