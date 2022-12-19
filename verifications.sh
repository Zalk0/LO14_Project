#!/bin/bash

function test_machine { #$1=machine
	file="./machines"
	compt=0
	while read -r ligne
	do
		machine=$(echo $ligne | cut -f1)
		if [[ "$1" = "$machine" ]]; then
			break
		else
			((compt++))
		fi
	done < $file
	len=$(wc -l $file | cut -d ' ' -f1)
	if [[ $compt -eq $len ]]; then
		return 1 #The machine doesn't exist
	else
		return 0 #The machine exists
	fi
}

function test_user { #$1=user
	file="./users"
	compt=0
	while read -r ligne
	do
		user=$(echo $ligne | cut -d ':' -f1)
		if [[ "$1" = "$user" ]]; then
			ligne=$((compt+1))
			break
		else
			((compt++))
		fi
	done < $file
	len=$(wc -l $file | cut -d ' ' -f1)
	if [[ $compt -eq $len ]]; then
		return 2 #The user doesn't exist
	else
		return 0 #The user exists
	fi
}

function test_user_access_machine { #$1=machine $2=user
	test_machine $1
	if [[ $? == 0 ]]; then
		test_user $2
		if [[ $? == 0 ]]; then
			machines=$(sed -n "$ligne"p $file | cut -d ':' -f3)
			if [[ $(echo $machines | grep $1) == '' ]]; then
				return 3 #The user doesn't have access to the machine
			else
				return 0 #The user has access to the machine
			fi
		else
			return 2 #The user doesn't exist
		fi
	else
		return 1 #The machine doesn't exist
	fi
}

#First arg is a number calling the test associated

if [[ ($# == 2) || ($# == 3) ]]; then
	case $1 in
		0 )
			test_machine $2
			return $?;;
		1 )
			test_user $2
			return $?;;
		2 )
			test_user_access_machine $2 $3
			return $?;;
		* )
			echo "First arg unknown"
	esac
else
	echo "Incorrect number of args when calling verifications!"
fi
