#!/bin/bash
source ./configParser.sh

# file="/home/jarvis/Development/4_runssh/config/config.runssh"


<<comment
Parameters: (string filename)
return: void
comment
function initClientConf(){
    if test -f $1
    then
        export RUNSSH_BARCONF="$1"
    else
        echo "ERROR - NO CONFIG FILE NOT FOUND"
        return 1
    fi
}


<<comment
Parameters: (string item)
return: various
comment
function clientConf(){
    case $1 in
        options)
            echo $(getOptions $RUNSSH_BARCONF $(getPrefixes $RUNSSH_BARCONF) )
            ;;
        attribute)
            if [ $# -lt 2 ]
            then
                return 1 
            fi
            echo $( (getAttributes $(getOptions $RUNSSH_BARCONF "2_")) )
            ;;
        values)
            if [ $# -lt 2 ]
            then
                return 1
            fi
            echo $( (getValues $(getOptions $RUNSSH_BARCONF "2_")) )
            ;;
        *)
            return 1
            ;;
    esac
}