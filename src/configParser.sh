#!/bin/bash

file="/home/jairo/Development/2_Runssh/config/config.runssh"

function getPrefixes(){
	prfx=$(grep -n prefix $1 | cut -d ":" -f 1)
	line=$(sed -n 1p $1)
	echo $line
# while IFS=: read -r -a pfxs
# do
#	printf 'prefixes= %s\n' "$f2"
# done < $1
}

getPrefixes $file
