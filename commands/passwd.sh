#!/bin/bash

file="./users"
cat f$ile
user_name=$1 # trouver un moyen de recup le use_name de l'utilisateur en cours
read -ps "Enter your old password: " old_pwd
read -ps "Enter your new password: " password
sed -i "s/^$user_name:$old_pwd/$user_name:$password/" $file
echo "Your password has been modified."
