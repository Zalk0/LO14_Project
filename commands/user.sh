#!/bin/bash

function setpwd {
	read -sp "What's the new pasword? " password
	password=$(echo $password | sha256sum | cut -f1 -d ' ')
	sed -ri "s/^($user_name:).*:/\1$password:/" $file
	echo "Password has been set correctly"
}

function add_machine {
	source verifications.sh 2 $machine_name $user_name
	case $? in
		0 )
			echo "The user $user_name already has acces to the machine $machine_name"
			return 0;;
		2 )
			echo "The machine $machine_name doesn't exist"
			return 1;;
		4 )
			sed -ri "s/^($user_name:.*:.*)( #.*|)$/\1,$machine_name\2/;s/:,/:/" $file
			return 0
	esac
}

file="./users"
echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
read -p "Do you want to remove, add, edit or set a password to an user? " option
if [[ ! (${option,,} == "add" || ${option,,} == "remove" || ${option,,} == "edit" || ${option,,} == "setpwd") ]]; then
	echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
	return
fi

read -p "What's the user name? " user_name
source verifications.sh 1 $user_name
case $? in
	0 )
		case ${option,,} in
			"remove" )
				while [[ true ]]; do
					read -p "Are you sure you want to delete $user_name, this action is irreversible!" choice
					case ${choice,,} in
						"yes" )
							sed -i "/^$user_name\b/d" $file
							echo "User $user_name deleted"
							break;;
						"no" )
							echo "You have cancelled"
							break;;
						* )
							echo "Wrong syntax, reply by 'yes' or 'no'!"
					esac
				done;;
			"edit" )
				while [[ true ]]; do
					read -p "Do you want to add or remove the permission to access a machine? " choice
					read -p "Which machine do you want? " machine_name
					case ${choice,,} in
						"add" )
							add_machine
							case $? in
								0 )
									break;;
								1 )
									:
							esac;;
						"remove" )
							source verifications.sh 2 $machine_name $user_name
							case $? in
								0 )
									sed -ri "s/^($user_name:.*:.*)$machine_name/\1/;s/(:|,),/\1/;s/,( )/\1/" $file
									echo "The user no longer has access to $machine_name"
									break;;
								2 )
									echo "The machine $machine_name doesn't exist";;
								4 ) 
									echo "The user doesn't have access to $machine_name"
									break
							esac;;
						* )
							echo "Wrong syntax, reply by 'add' or 'remove'!"
					esac
				done;;
			"setpwd" )
				setpwd;;
			"add" )
				echo "The user $user_name already exists";;
			* )
				echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
		esac;;
	3 )
		if [[ ${option,,} == "add" ]]; then
			echo "$user_name::" >> $file
			while [[ true ]]; do
				read -p "Do you want to add a machine or set a password to $user_name? " choice
				case ${choice,,} in
					"add" )
						read -p "Which machine do you want? " machine_name
						add_machine
						case $? in
							0 )
								break;;
							1 )
								:
						esac;;
					"setpwd" )
						setpwd
						break;;
					"no" )
						break;;
					* )
						echo "Wrong syntax, reply by 'add', 'setpwd' or 'no'!"
				esac
			done
		else
			echo "The user $user_name doesn't exist"
		fi;;
	6 )
		echo "The user name must only contain miniscule letters and digits"
esac
