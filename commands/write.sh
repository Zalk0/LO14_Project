#!/bin/bash

if [[ $# ]]
names=$1
message=$2
file="./messages"
log="./logs"

user_name=$(echo $names | cut -d'@' -f1)
machine_name=$(echo $names | cut -d'@' -f2)

while read ligne
do
    if [[ $(echo $ligne | grep "$machine_name-$user_name") != '' ]]; then
        ttyrec=$(echo $ligne | grep "$machine_name-$user_name" | cut -d '-' -f4)
        echo $message > $ttyrec
        compt=1
    fi
done < $log

if [[ compt -ne 1 ]]; then
    echo "User not connected"
fi
