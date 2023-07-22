#!/bin/bash

file="/home/jairo/Development/2_Runssh/config/config.runssh"

function getPrefixes(){
	local -a prfx=()
	#Search prefix then get 2nd field after > and replace ":" for whitespace
	prfx=$(grep -n prefix $1 | cut -d ">" -f 2 | awk '{ gsub(/:/," ");print}')
	echo ${prfx[@]}
}

items=( $(getPrefixes $file) )

echo ${#items[@]}
