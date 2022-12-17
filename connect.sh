#!/bin/bash

#TODO @Zalk0 - @Gylfirst

function rsvh() {
    if [ $# -eq 1 ] && [ "$1" = "-admin" ]; then
        read -sp "What's the pasword for admin?" admin_passwd
        echo -e "\nThe admin password is: $admin_passwd"
    elif [ $# -eq 3 ] && [ "$1" = "-connect" ]; then
        file="./machines"
        compt=0
        while read -r ligne
        do
            machine=$(echo $ligne | cut -f1)
            if [ "$2" = "$machine" ]; then
                break
            else
                ((compt++))
            fi
        done < $file
        len=$(wc -l $file | cut -d ' ' -f1)
        if [[ $compt -eq $len ]]; then
            echo "The specified machine doesn't exist."
        else
            read -sp "What's your password $3?" user_passwd
            echo -e "\nYour password is: $user_passwd"
        fi
    elif [ $# -eq 1 ] && [ "$1" = "-help" ]; then
        help
    else
        syntax
    fi
}

function syntax() {
    echo -e "Syntax:\n\trsvh -admin\n\trsvh -connect machine_name user_name"
}

function help() {
    echo -e "HELP for rsvh command\n------------------------"
    syntax
    echo -e "------------------------\nCommands for -connect"
    echo "who:"
    echo "rusers:"
    echo "host:"
    echo "rconnect:"
    echo "su:"
    echo "passwd:"
    echo "finger:"
    echo -e "write: allow the user to send message to another user.\n\tSyntax: write user_name@machine_name message"
    echo "exit:"
    echo -e "------------------------\nCommands for -admin"
    echo "host:"
    echo "user:"
    echo -e "wall: allow the admin to send a message to connected users/not connected users following the syntax:\n\twall message (for only connected users)\n\twall -n message (for all users)"
    echo "afinger:"
}


## COMMANDE DE TEST
# rsvh -admin
# rsvh -connect machine1 user
# rsvh -connect machine2 user
# rsvh -help
# rsvh dzq