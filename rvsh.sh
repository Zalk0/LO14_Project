#!/bin/bash

#TODO @Zalk0 - @Gylfirst
#Gonna use source to call functions

function syntax() {
	echo -e "Syntax:\n\trsvh -admin\n\trsvh -connect machine_name user_name"
}

#Je pense qu'il faut faire un help pour rvsh (pour comment on se connecte) et un help pour les autres commandes une fois connecté
function help() {
	echo -e "HELP for rsvh command\n------------------------"
	syntax
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
	echo -e "------------------------\nCommands for -admin"
	echo "host: allow the administrator to add or remove a virtual machine in the network"
	echo "user: allow the administrator to add or remove an user, edit his permitions, and set a password"
	echo -e "wall: allow the administrator to send a message to connected users/not connected users following the syntax:\n\twall message (for only connected users)\n\twall -n message (for all users)"
	echo "afinger: allow the administrator to edit the informations on a user"
}

#Need to add usage of verifications.sh

if [ $# -eq 1 ] && [ "$1" = "-admin" ]; then
	read -sp "What's the pasword for admin? " admin_passwd
	admin_passwd=$(echo $admin_passwd | sha256sum | cut -f1 -d ' ')
	echo -e "\nThe hash of the admin password is: $admin_passwd"
elif [ $# -eq 3 ] && [ "$1" = "-connect" ]; then
	source verifications.sh 2 $2 $3
	case $? in
		0 )
			read -sp "What's your password $3? " user_passwd
			user_passwd=$(echo $user_passwd | sha256sum | cut -f1 -d ' ')
			echo -e "\nThe hash of your password is: $user_passwd";;
		1 )
			echo "The machine doesn't exist";;
		2 )
			echo "The user doesn't exist";;
		3 )
			echo "This user doesn't have access to this machine"
	esac
elif [ $# -eq 1 ] && [ "$1" = "-help" ]; then
	help
else
	syntax
fi

## COMMANDE DE TEST
# rsvh -admin
# rsvh -connect machine1 user
# rsvh -connect machine2 user
# rsvh -help
# rsvh dzq
# rhost
# finger user
# finger user1
# afinger
# host
# user
