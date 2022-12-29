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
		return 2 #The machine doesn't exist
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
		return 3 #The user doesn't exist
	else
		return 0 #The user exists
	fi
}

function test_user_access_machine { #$1=machine $2=user
	test_machine $1
	if [[ $? != 0 ]]; then
		return 2 #The machine doesn't exist
	fi
	test_user $2
	if [[ $? != 0 ]]; then
		return 3 #The user doesn't exist
	fi
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

function test_pwd_admin { #$1=password
	file="./admin"
	pwd=$(sed -n 1p $file | cut -d ':' -f2)
	if [[ "$pwd" != "$1" ]]; then
		return 5 #The password isn't correct
	fi
	return 0 #The password is correct
}

#First arg is a number calling the test associated

if [[ ($# < 2) || ($# > 3) ]]; then
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
	4 )
		test_pwd_admin $2
		return $?;;
	* )
		echo "First arg unknown"
esac
