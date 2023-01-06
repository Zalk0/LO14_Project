#!/bin/bash

if [[ $(echo $1 | grep '^-n$') == '' ]]; then
    # write message for all onlines
    message=$1+${@:2}
    log="./logs"
    while read ligne
    do
        ttyrec=$(echo $ligne | cut -d '-' -f4)
        echo -e "\nMessage from root: $message" > $ttyrec
    done < $log
elif [[ $(echo $1 | grep '^-n$') == '-n' ]]; then
    # save message for offlines
        message=${@:2}
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
            sed '/'$user_name'/d' $file > $temp
            mv $temp $file
            rm -f $temp
            echo -e "\nMessage from root: $message" > $ttyrec
        done < $log
else
    echo "Wrong syntax"
fi