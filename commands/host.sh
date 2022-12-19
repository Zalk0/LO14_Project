#!/bin/bash

file="./machines"
cat $file
read -p "Do you want to remove or add a machine? " option
if [ "$option" = "remove" ]; then
	read -p "What's the machine name? " machine_name
	sed -i -r "/$machine_name\b/d" $file
	echo "New file:"
	cat $file
elif [ "$option" = "add" ]; then
	read -p "What's the machine name? " machine_name
	echo $machine_name >> $file
else
	echo "Reply by 'add' or 'remove'!"
fi
