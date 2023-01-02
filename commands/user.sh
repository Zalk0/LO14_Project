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
cat $file
echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
read -p "Do you want to remove, add, edit or set a password to an user? " option
read -p "What's the user name? " user_name

source verifications.sh 1 $user_name
case $? in
	0 )
		case $option in
			"remove" )
				sed -i "/^$user_name\b/d" $file;;
			"edit" )
				read -p "Do you want to add, remove or edit a permission? " choice
				read -p "Which machine do you want? " machine_name
				case $choice in
					"add" )
						add_machine;;
					"remove" )
						# sed -i "" $file
						;;
					"edit" )
						# sed -i "^$user_name\b" $file
						;;
					* )
						echo "Wrong syntax, reply by 'add', 'remove' or 'edit'!"
				esac;;
				#TODO faire les edit de permisisons (modifier peut etre le setpwd)
			"setpwd" )
				setpwd;;
			"add" )
				echo "The user $user_name already exists";;
			* )
				echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
		esac;;
	3 )
		if [[ $option == "add" ]]; then
			echo "$user_name::" >> $file
			read -p "Do you want to add a machine or set a password to $user_name? " option
			case $option in
				"add" )
					add_machine;;
				"setpwd" )
					setpwd;;
				* )
					echo "Wrong syntax, reply by 'add', 'remove' or 'edit'!"
			esac
		else
			echo "The user $user_name doesn't exist"
		fi
esac

echo "New file:"
cat $file
