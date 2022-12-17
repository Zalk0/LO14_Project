#!/bin/bash

#TODO @Zalk0 - @Gylfirst

function rsvh() {
    if [[ $# -eq 1 && $1=='-admin' ]]; then
        echo "What's the pasword for admin?"

    elif [[ $# -eq 3 && $1=='-connect' ]];then
        echo "What's your password $3?"

    elif [[ $# -eq 1 && $1=='-help' ]];then
        help
    else
        error
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