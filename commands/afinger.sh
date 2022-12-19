#!/bin/bash

file="./finger"
read -p "Which user do you want to edit? " user_name
while read -r ligne
do
	((nb_tot_ligne++))
	name=$(echo $ligne | cut -d' ' -f1 )
	if [ "$name" = "$user_name" ]; then
		echo -e "The information of $user_name is:\n$(echo $ligne | cut -d':' -f2)"
		nb_ligne=$nb_tot_ligne
	else
		echo "The user $name is not registered."
	fi
done < $file
#TODO @Gylfirst - @zalk0 Il faut maintenant ajouter/réécrire les infos avec un read et à la bonne position
