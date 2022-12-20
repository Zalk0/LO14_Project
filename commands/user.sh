#!/bin/bash

file="./users"
cat $file
echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
read -p "Do you want to remove, add, edit or set a password to an user? " option
read -p "What's the user name? " user_name
#TODO faire une vérif que le user existe bien (pour setpwd, edit, remove)
if [ "$option" = "remove" ]; then
	sed -i "/^$user_name\b/d" $file
elif [ "$option" = "add" ]; then
	echo '$user_name::' >> $file
elif [ "$option" = "edit" ]; then
	read -p "Do you want to add, remove or edit a permission? " choice
	read -p "Which machine do you want? " machine_name
	if [ "$choice" = "add" ]; then
		# sed -i "^$user_name\b" $file
	elif [ "$choice" = "remove" ]; then
		# sed -i "" $file
	elif [ "$choice" = "edit" ]; then
		# sed -i "^$user_name\b" $file
	else
		echo "Wrong syntax, reply by 'add', 'remove' or 'edit'!"
	fi
	#TODO faire les edit de permisisons (modifier peut etre le setpwd)
elif [ "$option" = "setpwd" ]; then
	read -p "What's the new pasword? " password
	sed -i "s/^$user_name:/$user_name:$password/" $file
	echo "Password has been set correctly"
else
	echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
fi
echo "New file:"
cat $file
