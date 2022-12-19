#!/bin/bash

file="./users"
cat $file
echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
read -p "Do you want to remove, add, edit or set a password to an user? " option
read -p "What's the user name? " user_name
#TODO faire une vérif que le user existe bien (pour setpwd, edit, remove)
if [ "$option" = "remove" ]; then
	sed -i -r "/^$user_name\b/d" $file
elif [ "$option" = "add" ]; then
	echo $user_name >> $file
elif [ "$option" = "edit" ]; then
	sed -i -r "^$user_name\b" $file
	#TODO faire les edit de permisisons (modifier peut etre le setpwd)
elif [ "$option" = "setpwd" ]; then
	read -p "What's the new pasword? " password
	sed -i -r "s/^$user_name.*/$user_name:$password/" $file
	echo "Password has been set correctly"
else
	echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
fi
echo "New file:"
cat $file
