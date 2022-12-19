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
		return 0 #The machine doesn't exist
	else
		return 1 #The machine exists
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
		return 0 #The user doesn't exist
	else
		return 1 #The user exists
	fi
}

function test_user_access_machine { #$1=machine $2=user
	test_user $2
	if [[ $? == 1 ]]; then
		machines=$(sed -n "$ligne"p $file | cut -d ':' -f2)
		if [[ $(echo $machines | grep $1) == '' ]]; then
			return 0 #The user doesn't have access to the machine
		else
			return 1 #The user has access to the machine
		fi
	fi
}

#First arg is a number calling the test associated

if [[ $# != 0 ]]; then
	if [[ $1 == 0 ]]; then #$1=0 $2=machine
		if [[ $# == 2 ]]; then
			test_machine $2
			echo $?
		else
			echo "Incorrect number of args when calling verifications!"
		fi
	elif [[ $1 == 1 ]]; then #$1=1 $2=user
		if [[ $# == 2 ]]; then
			test_user $2
			echo $?
		else
			echo "Incorrect number of args when calling verifications!"
		fi
	elif [[ $1 == 2 ]]; then #$1=2 $2=machine $3=user
		if [[ $# == 3 ]]; then
			test_user_access_machine $2 $3
			echo $?
		else
			echo "Incorrect number of args when calling verifications!"
		fi
	else
		echo "Incorrect first arg when calling verifications!"
	fi
else
	echo "Forgot arg when calling verifications!"
fi
