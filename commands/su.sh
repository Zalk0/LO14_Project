#!/bin/bash

file="./users"
new_user=$1
if [[ $(cat $file | grep -c "$new_user") -eq 1 ]]; then
	#TODO @Gylfirst trouver comment modif le prompt
	(echo $PS1 | sed -r "s/\\u/$new_user/")
	echo 'test $PS1'
else
	echo "User not found"
fi
