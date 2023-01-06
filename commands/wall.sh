#!/bin/bash

col_green=$'\e[1;32m'
col_default=$'\e[0m'

user_name=$1
machine_name=$2

if [[ $(echo $3 | grep '^n$') == '' ]]; then
    # write message for all onlines
    message=${@:3}
    log="./logs"
    while read ligne
    do
        ttyrec=$(echo $ligne | cut -d '-' -f4)
        user_name=$(echo $ligne | cut -d '-' -f2)
        machine_name=$(echo $ligne | cut -d '-' -f1)
        echo -e "\nMessage from root: $message" > $ttyrec
        if [[ $user_name != 'root' ]];then
            echo -n "$col_green$user_name@$machine_name$col_default> " > $ttyrec
        fi
    done < $log
elif [[ $(echo $3 | grep '^n$') == 'n' ]]; then
    # save message for offlines
    message=${@:4}
    file="./messages"
    log="./logs"
    users="./users"
    temp="./tempfile"
    while read ligne
    do
        user_name=$(echo $ligne | cut -d ':' -f1)
        echo $user_name:$message >> $file
    done < $users
    while read ligne
    do
        ttyrec=$(echo $ligne | cut -d '-' -f4)
        user_name=$(echo $ligne | cut -d '-' -f2)
        machine_name=$(echo $ligne | cut -d '-' -f1)
        sed '/'$user_name'/d' $file > $temp
        mv $temp $file
        rm -f $temp
        echo -e "\nMessage from root: $message" > $ttyrec
        if [[ $user_name != 'root' ]];then
            echo -n "$col_green$user_name@$machine_name$col_default> " > $ttyrec
        fi
    done < $log
else
    echo "Wrong syntax"
fi
