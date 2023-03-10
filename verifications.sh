#!/bin/bash

function test_machine { #$1=machine
	if [[ $1 =~ [^0-9a-z]+ ]]; then
		return 6 #The user name or machine name contains not allowed characters
	fi
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
		return 2 #The machine doesn't exist
	else
		return 0 #The machine exists
	fi
}

function test_user { #$1=user
	if [[ $1 =~ [^0-9a-z]+ ]]; then
		return 6 #The user name or machine name contains not allowed characters
	fi
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
		return 3 #The user doesn't exist
	else
		return 0 #The user exists
	fi
}

function test_user_access_machine { #$1=machine $2=user
	test_machine $1
	case $? in
		2 )
			return 2;; #The machine doesn't exist
		6 )
			return 6 #The user name or machine name contains not allowed characters
	esac
	test_user $2
	case $? in
		3 )
			return 3;; #The user doesn't exist
		6 )
			return 6 #The user name or machine name contains not allowed characters
	esac
	machines=$(sed -n "$ligne"p $file | cut -d ':' -f3)
	if [[ $(echo $machines | grep $1) == '' ]]; then
		return 4 #The user doesn't have access to the machine
	fi
	return 0 #The user has access to the machine
}

function test_pwd { #$1=user $2=password
	test_user $1
	pwd=$(sed -n "$ligne"p $file | cut -d ':' -f2)
	if [[ "$pwd" != "$2" ]]; then
		return 5 #The password isn't correct
	fi
	return 0 #The password is correct
}

#First arg is a number calling the test associated

if [[ ($# < 2) || ($# > 3) ]]; then
	echo "Incorrect number of args when calling verifications"
	return 1
fi
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
	3 )
		test_pwd $2 $3
		return $?;;
	* )
		echo "First arg unknown"
esac
