#!/bin/bash

file="./users"
cat f$ile
user_name=$1 # trouver un moyen de recup le use_name de l'utilisateur en cours
read -sp "Enter your old password: " old_pwd
old_pwd=$(echo $old_pwd | sha256sum | cut -f1 -d ' ')
read -sp "Enter your new password: " password
password=$(echo $password | sha256sum | cut -f1 -d ' ')
sed -i "s/^$user_name:$old_pwd/$user_name:$password/" $file
echo "Your password has been modified."
