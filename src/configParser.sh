#!/bin/bash

file="/home/jairo/Development/2_Runssh/config/config.runssh"

function getPrefixes(){
	local -a prfx=()
	#Search prefix then get 2nd field after > and replace ":" for whitespace
	prfx=$(grep -n prefix $1 | cut -d ">" -f 2 | awk '{ gsub(/:/," ");print}')
	echo ${prfx[@]}
}

function getOptions(){
	local -a opts=()
	fileName=$1
	opts=$(grep ^$2[A-Za-z]* $fileName)
	echo ${opts[@]}
}

function getAttributes(){
	echo $(echo $1 | cut -d ">" -f 1)
}

function getValues(){
	echo $(echo $1 | cut -d ">" -f 2)
}

items=( $(getPrefixes $file) )

#echo ${#items[@]}

#getOptions $file "1_"

for i in ${items[@]}
do
	for opt in $(getOptions $file $i)
	do
		echo $(getAttributes $opt)
		echo $(getValues $opt)
	done
done
