#!/bin/bash

file="/home/jairo/Development/2_Runssh/config/config.runssh"


<<comment
Paremeters:(string filename)
Returns: [string] prfx
comment
function getPrefixes(){
	local -a prfx=()
	#Search prefix then get 2nd field after > and replace ":" for whitespace
	prfx=$(grep -n prefix $1 | cut -d ">" -f 2 | awk '{ gsub(/:/," ");print}')
	echo ${prfx[@]}
}

<<comment
Paremeters: (string filename, string Prefix)
Returns: [string] opts
comment
function getOptions(){
	local -a opts=()
	fileName=$1
	opts=$(grep ^$2[A-Za-z]* $fileName)
	echo ${opts[@]}
}

<<comment
Paremeters:(string Option)
Returns: string attribute
comment
function getAttributes(){
	attribute=$(echo $1 | cut -d ">" -f 1)
	echo $attribute
}

<<comment
Paremeters:(string Option)
Returns: string attribute
comment
function getValues(){
	value=$(echo $1 | cut -d ">" -f 2)
	echo $value
}

<<comment
Paremeters:(string filename, [string] prefixes)
Returns: bool
comment
function missingOptions(){
	local -a prfxs=()
	prfxs=("${@:2:$#}")

	for p in ${prfxs[@]}
	do
		if grep -q ^$p $1
		then
			missing=false
		else
			missing=true
		fi
	done

	echo $missing
}

items=( $(getPrefixes $file) )


#getOptions $file "1_"

# for i in ${items[@]}
# do
# 	for opt in $(getOptions $file $i)
# 	do
# 		echo $(getAttributes $opt)
# 		echo $(getValues $opt)
# 	done
# done


echo $(missingOptions $file ${items[@]})