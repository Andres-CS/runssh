#!/bin/bash

##
# Paremeters: (string filename)
# Returns: [string] prfx
##
function getPrefixes(){
	local -a prfx=()
	#Search prefix then get 2nd field after > and replace ":" for whitespace
	prfx=$(grep -n prefix $1 | cut -d ">" -f 2 | awk '{ gsub(/:/," ");print}')
	echo ${prfx[@]}
}

##
# Paremeters: (string filename, string Prefix)
# Returns: [string] opts
##
function getOptions(){
	local -a opts=()
	fileName=$1
	opts=$(grep ^$2[A-Za-z]* $fileName)
	echo ${opts[@]}
}

##
# Parameters:([string] Options)
# Returns: [string] attributes
##
function getAttributes(){
	local -a arrayAtributes=()
	for opt in $@
	do
		arrayAtributes+=($(getAttribute $opt))
	done
	echo ${arrayAtributes[@]}
}
 
##
# Paremeters:(string Option)
# Returns: string attribute
##
function getAttribute(){
	attribute=$(echo $1 | cut -d ">" -f 1)
	echo $attribute
}

##
# Parameters:([string] Options)
# Returns: [string] values
##
function getValues(){
	local -a arrayValues=()
	for opt in $@
	do
		arrayValues+=($(getValue $opt))
	done
	echo ${arrayValues[@]}
}

##
# Paremeters:(string Option)
# Returns: string value
##
function getValue(){
	value=$(echo $1 | cut -d ">" -f 2)
	echo $value
}

##
# Paremeters:(string filename, [string] prefixes)
# Returns: bool
##
function missingOptions(){
	local -a prfxs=()
	#Slice arg array from pos 2.
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

# items=( $(getPrefixes $file) )


# getOptions $file "1_"

# for i in ${items[@]}
# do
# 	for opt in $(getOptions $file $i)
# 	do
# 		echo $(getAttributes $opt)
# 		echo $(getValues $opt)
# 	done
# done


# atts=( $(getAttributes $(getOptions $file "2_")) )
# for a in ${atts[@]}
# do
# 	echo $a
# done

# echo $(missingOptions $file ${items[@]})