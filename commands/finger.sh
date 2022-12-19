#!/bin/bash

#TODO @Gylfirst - Il manque la façon de recup le user_name
file="./finger"
user_name=$1
while read ligne
do
	name=$(echo $ligne | cut -d' ' -f1 )
	if [ "$name" = "$user_name" ]; then
		echo $(echo $ligne | cut -d':' -f2 )
	else
		echo "The user $name is not registered."
	fi
done < $file
