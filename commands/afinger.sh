#!/bin/bash

file="./finger"
read -ep "Which user do you want to edit? " user_name
while read -r ligne
do
	((nb_tot_ligne++))
	name=$(echo $ligne | cut -d' ' -f1 )
	if [ "$name" = "$user_name" ]; then
		echo -e "The information of $user_name is:\n$(echo $ligne | cut -d':' -f2)"
		compt=1
	fi
done < $file

if [[ $compt -eq 1 ]]; then
	read -ep "Do you want to add or edit informations? " choise
	case $choise in 
		"add" )
			read -ep "What do you want to add: " text
			info=$(grep "^$user_name info:" $file)
			sed -i "s/$info/$info,$text/" $file;;
		"edit" )
			read -ep "What do you want to edit: " text
			read -ep "Remplace by: " replace
			sed -ri "s/^($user_name info:.*)$text/\1$replace/" $file;;
		* )
			echo "Wrong argument"
	esac
else
	echo "$user_name is not registered"
fi
