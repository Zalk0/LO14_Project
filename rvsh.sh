#!/bin/bash

#TODO @Zalk0 - @Gylfirst
#Gonna use source to call functions

col_green=$'\e[1;32m'
col_default=$'\e[0m'

function syntax {
	echo -e "Syntax:\n\trsvh -admin\n\trsvh -connect machine_name user_name"
}

function help_connect {
	echo -e "------------------------\nCommands for -connect"
	echo "who: allow the user to display all the users connected on the machine, returning username, machine name, date and hour of connection"
	echo "rusers: allow the user to display the connected users, returning username, machine name, date and hour of connection"
	echo "rhost: allow the user to display the list of virtual machine connected to the network"
	echo "rconnect: allow the user to connect to another virtual machine of the network"
	echo "su: allow the user to change the current user"
	echo "passwd: allow the user to change his password on the network"
	echo "finger: allow the user to display his informations"
	echo -e "write: allow the user to send message to another user.\n\tSyntax: write user_name@machine_name message"
	echo "exit: allow the user to quit the current virtual machine, returning on the precedent, or leaving the network"
}

function help_admin {
	help_connect
	echo -e "------------------------\nCommands for -admin"
	echo "host: allow the administrator to add or remove a virtual machine in the network"
	echo "user: allow the administrator to add or remove an user, edit his permitions, and set a password"
	echo -e "wall: allow the administrator to send a message to connected users/not connected users following the syntax:\n\twall message (for only connected users)\n\twall -n message (for all users)"
	echo "afinger: allow the administrator to edit the informations on a user"
}

function help {
	echo -e "HELP for rsvh command\n------------------------"
	syntax
	help_admin
}

function connection {
	trap "" SIGINT
	echo ""
	date=$(date)
	terminal=$(tty)
	echo $1-$2-$date-$terminal >> logs # machine-user-date-terminal
	mess="./messages"
	if [[ ! -f $mess ]]; then
		return
	fi
	temp="./tempfile"
	while read ligne
	do
		if [[ $(echo $ligne | grep $2) != '' ]]; then
			message=$(echo $ligne | cut -d ':' -f2)
			echo "Message from root: $message"
			sed '/'$user_name'/d' $mess > $temp
            mv $temp $mess
            rm -f $temp
		fi
	done < $mess
}

function prompt_admin { #$1=machine $2=user
	while [[ true ]]; do
		read -p "$col_green$2@$1$col_default> " cmd a1 a2 a3
		case $cmd in
			"afinger" )
				source "./commands/afinger.sh";;
			"exit" )
				source "./commands/exit.sh" $2 $1;;
			"finger" )
				source "./commands/finger.sh" $2;;
			"help" )
				help_admin;;
			"host" )
				source "./commands/host.sh";;
			"passwd" )
				source "./commands/passwd.sh" $2;;
			"rconnect" )
				source "./commands/rconnect.sh" "admin" $2 $a1;;
			"rhost" )
				source "./commands/rhost.sh";;
			"rusers" )
				source "./commands/rusers.sh";;
			"su" )
				if [ -z $a1 ] || [ -z $a2 ]; then
					echo "Enter the user to access and the machine"
					continue
				fi
				source "./commands/su.sh" $a2 $a1;;
			"user" )
				source "./commands/user.sh";;
			"wall" )
				source "./commands/wall.sh" $a1 $a2;;
			"who" )
				source "./commands/who.sh" $1;;
			"write" )
				source "./commands/write.sh" $a1 $a2 $2 $1;;
			* )
				help_admin
		esac
	done
}

function prompt_connect { #$1=machine $2=user
	while [[ true ]]; do
		read -p "$col_green$2@$1$col_default> " cmd a1 a2 a3
		case $cmd in
			"exit" )
				source "./commands/exit.sh" $2 $1;;
			"finger" )
				source "./commands/finger.sh" $2;;
			"help" )
				help_connect;;
			"passwd" )
				source "./commands/passwd.sh" $2;;
			"rconnect" )
				source "./commands/rconnect.sh" "connect" $2 $a1;;
			"rhost" )
				source "./commands/rhost.sh";;
			"rusers" )
				source "./commands/rusers.sh";;
			"su" )
				if [ -z $a1 ]; then
					echo "Enter the user to access"
					continue
				fi
				source "./commands/su.sh" $1 $a1;;
			"who" )
				source "./commands/who.sh" $1;;
			"write" )
				source "./commands/write.sh" $a1 $a2 $2 $1;;
			* )
				help_connect
		esac
	done
}

function prompt { #$1=mode $2=machine $3=user
	if [[ $1 == "admin" ]]; then
		connection $2 $3
		prompt_admin $2 $3
	elif [[ $1 == "connect" ]]; then
		connection $2 $3
		prompt_connect $2 $3
	fi
}

if [ $# -eq 1 ] && [ $1 == "-admin" ]; then
	read -sp "What's the pasword for admin? " admin_passwd
	admin_passwd=$(echo $admin_passwd | sha256sum | cut -f1 -d ' ')
	#echo -e "\nThe hash of the admin password is: $admin_passwd"
	source verifications.sh 3 "root" $admin_passwd
	case $? in
		0 )
			prompt $(echo $1 | cut -f2 -d '-') "hostroot" "root";;
		5 )
			echo "The password isn't correct"
	esac
elif [ $# -eq 3 ] && [ $1 == "-connect" ]; then
	source verifications.sh 2 $2 $3
	case $? in
		0 )
			read -sp "What's your password $3? " user_passwd
			user_passwd=$(echo $user_passwd | sha256sum | cut -f1 -d ' ')
			#echo -e "\nThe hash of your password is: $user_passwd"
			source verifications.sh 3 $3 $user_passwd
			case $? in
				0 )
					prompt $(echo $1 | cut -f2 -d '-') $2 $3;;
				5)
					echo "The password isn't correct"
			esac;;
		1 )
			echo "Incorrect number of args when calling verifications!";;
		2 )
			echo "The machine doesn't exist";;
		3 )
			echo "The user doesn't exist";;
		4 )
			echo "This user doesn't have access to this machine"
	esac
elif [ $# -eq 1 ] && [ $1 == "-help" ]; then
	help
elif [ $# -eq 1 ] && [ $1 == "rconnect" ]; then
	: #do nothing
else
	syntax
fi
