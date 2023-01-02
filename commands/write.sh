#!/bin/bash

col_green=$'\e[1;32m'
col_default=$'\e[0m'

if [[ $# -eq 4 ]]; then
    names=$1
    message=$2
    from_user=$3
    from_machine=$4
    file="./messages"
    log="./logs"
    
    if [[ $(echo $names | grep '@') == '' ]]; then
        echo "Wrong syntax"
        return
    fi

    user_name=$(echo $names | cut -d'@' -f1)
    machine_name=$(echo $names | cut -d'@' -f2)

    while read ligne
    do
        if [[ $(echo $ligne | grep "$machine_name-$user_name") != '' ]]; then
            ttyrec=$(echo $ligne | grep "$machine_name-$user_name" | cut -d '-' -f4)
            echo -e "\nMessage from $from_user: $message" > $ttyrec
            echo -n "$col_green$user_name@$machine_name$col_default> " > $ttyrec
            compt=1
        fi
    done < $log

    if [[ $compt -ne 1 ]]; then
        echo "User not connected or machine doesnt exist"
    fi
else
    echo "Wrong syntax"
fi