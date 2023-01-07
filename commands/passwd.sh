#!/bin/bash

file="./users"
cat $file
user_name=$1
read -esp "Enter your old password: " old_pwd
old_pwd=$(echo $old_pwd | sha256sum | cut -f1 -d ' ')
source ./verifications.sh 3 $user_name $old_pwd
case $? in
	0 )
		echo "The password is correct"
		read -esp "Enter your new password: " password
		password=$(echo $password | sha256sum | cut -f1 -d ' ')
		sed -i "s/^$user_name:$old_pwd/$user_name:$password/" $file
		echo "Your password has been modified.";;
	5)
		echo "The password isn't correct"
esac
