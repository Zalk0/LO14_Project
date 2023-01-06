#!/bin/bash

file="./finger"
user_name=$1
while read ligne
do
	name=$(echo $ligne | cut -d ' ' -f1 )
	if [ "$name" = "$user_name" ]; then
		echo $(echo $ligne | cut -d ':' -f2 )
		compt=1
		break
	fi
done < $file
if [[ $compt -ne 1 ]]; then # if the user is created manually in the users file
	echo "The user $user_name is not registered."
fi
