#!/bin/bash

file="./users"
cat $file
echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
read -p "Do you want to remove, add, edit or set a password to an user? " option
read -p "What's the user name? " user_name
#TODO faire une vérif que le user existe bien (pour setpwd, edit, remove)
case $option in
	"remove" )
		sed -i "/^$user_name\b/d" $file;;
	"add" )
		echo "$user_name::" >> $file;;
	"edit" )
		read -p "Do you want to add, remove or edit a permission? " choice
		read -p "Which machine do you want? " machine_name
		case $choice in
			"add" )
				# sed -i "^$user_name\b" $file
				;;
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
		read -p "What's the new pasword? " password
		password=$(echo $password | sha256sum | cut -f1 -d ' ')
		sed -i "s/^$user_name:.*:/$user_name:$password:/" $file
		echo "Password has been set correctly";;
	* )
		echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
esac
echo "New file:"
cat $file
