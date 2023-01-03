#!/bin/bash

function setpwd {
	read -p "What's the new pasword? " password
	password=$(echo $password | sha256sum | cut -f1 -d ' ')
	sed -i "s/^$user_name:.*:/$user_name:$password:/" $file
	echo "Password has been set correctly"
}

function add_machine {
	source verifications.sh 2 $machine_name $user_name
	case $? in
		0 )
			echo "The user $user_name already has acces to the machine $machine_name";;
		2 )
			echo "The machine $machine_name doesn't exist";;
		4 )
			sed -ri "s/^($user_name:.*:.*) (#.*)$/\1,$machine_name \2/" $file
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
				read -p "Are you sure you want to delete $user_name, this action is irreversible!" choice
				case ${choice,,} in
					"yes" )
						sed -i "/^$user_name\b/d" $file
						echo "User $user_name deleted";;
					"no" )
						echo "You have cancelled"
						:;;
					* )
						echo "Wrong syntax, reply by 'yes' or 'no'!"
				esac;;
			"edit" )
				read -p "Do you want to add or remove the permission to access a machine? " choice
				read -p "Which machine do you want? " machine_name
				case ${choice,,} in
					"add" )
						add_machine;;
					"remove" )
						sed -ri "s/^($user_name:.*:.*)($machine_name,|,$machine_name)(.* #.*)$/\1\3/" $file;;
					* )
						echo "Wrong syntax, reply by 'add' or 'remove'!"
				esac;;
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
			read -p "Do you want to add a machine or set a password to $user_name? " choice
			case ${choice,,} in
				"add" )
					read -p "Which machine do you want? " machine_name
					add_machine;;
				"setpwd" )
					setpwd;;
				"no" )
					:;;
				* )
					echo "Wrong syntax, reply by 'add', 'setpwd' or 'no'!"
			esac
		else
			echo "The user $user_name doesn't exist"
		fi
esac
