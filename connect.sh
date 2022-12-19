#!/bin/bash

#TODO @Zalk0 - @Gylfirst

function rsvh() {
    if [ $# -eq 1 ] && [ "$1" = "-admin" ]; then
        read -sp "What's the pasword for admin? " admin_passwd
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
            read -sp "What's your password $3? " user_passwd
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
    echo "who: allow the user to display all the users connected on the machine, returning username, machine name, date and hour of connection"
    echo "rusers: allow the user to display the connected users, returning username, machine name, date and hour of connection"
    echo "rhost: allow the user to display the list of virtual machine connected to the network"
    echo "rconnect: allow the user to connect to another virtual machine of the network"
    echo "su: allow the user to change the current user"
    echo "passwd: allow the user to change his password on the network"
    echo "finger: allow the user to display his informations"
    echo -e "write: allow the user to send message to another user.\n\tSyntax: write user_name@machine_name message"
    echo "exit: allow the user to quit the current virtual machine, returning on the precedent, or leaving the network"
    echo -e "------------------------\nCommands for -admin"
    echo "host: allow the administrator to add or remove a virtual machine in the network"
    echo "user: allow the administrator to add or remove an user, edit his permitions, and set a password"
    echo -e "wall: allow the administrator to send a message to connected users/not connected users following the syntax:\n\twall message (for only connected users)\n\twall -n message (for all users)"
    echo "afinger: allow the administrator to edit the informations on a user"
}

# USER FUNCTIONS

function rhost() {
    file="./machines"
    echo "List of connected machines in the network:"
    while read ligne
    do
        echo $ligne
    done < $file    
}

function su() {
    file="./users"
    new_user=$1
    if [[ $(cat $file | grep -c "$new_user") -eq 1 ]]; then
        #TODO @Gylfirst trouver comment modif le prompt
        (echo $PS1 | sed -r "s/\\u/$new_user/")
        echo 'test $PS1'
    else
        echo "User not found"
    fi    
}

function finger() {
    #TODO @Gylfirst - Il manque la façon de recup le user_name
    file="./finger"
    user_name=$1
    while read ligne
    do
        name=$(echo $ligne | cut -d' ' -f1 )
        if [ "$name" = "$user_name" ]; then
            echo $(echo $ligne | cut -d':' -f2 )
        else 
            echo "The user $name is not registered."
        fi
    done < $file    
}

# ADMIN FUNCTIONS

function host() {
    file="./machines"
    cat $file
    read -p "Do you want to remove or add a machine? " option
    if [ "$option" = "remove" ]; then
        read -p "What's the machine name? " machine_name
        sed -i -r "/$machine_name\b/d" $file
        echo "New file:"
        cat $file
    elif [ "$option" = "add" ]; then
        read -p "What's the machine name? " machine_name
        echo $machine_name >> $file
    else
        echo "Reply by 'add' or 'remove'!"
    fi
}

function user() {
    file="./users"
    cat $file
    echo "Reply by 'add', 'remove', 'edit' or 'setpwd'"
    read -p "Do you want to remove, add, edit or set a password to an user? " option
    read -p "What's the user name? " user_name
    #TODO faire une vérif que le user existe bien (pour setpwd, edit, remove)
    if [ "$option" = "remove" ]; then
        sed -i -r "/^$user_name\b/d" $file
    elif [ "$option" = "add" ]; then
        echo $user_name >> $file
    elif [ "$option" = "edit" ]; then
        sed -i -r "^$user_name\b" $file
        #TODO faire les edit de permisisons (modifier peut etre le setpwd)
    elif [ "$option" = "setpwd" ]; then
        read -p "What's the new pasword? " password
        sed -i -r "s/^$user_name.*/$user_name:$password/" $file
        echo "Password has been set correctly"
    else
        echo "Wrong syntax, reply by 'add', 'remove', 'edit' or 'setpwd'!"
    fi
    echo "New file:"
    cat $file
}

function wall() {
    #TODO
    echo 'test'
}

function afinger() {
    file="./finger"
    read -p "Which user do you want to edit? " user_name
    while read -r ligne
    do
        ((nb_tot_ligne++))
        name=$(echo $ligne | cut -d' ' -f1 )
        if [ "$name" = "$user_name" ]; then
            echo -e "The information of $user_name is:\n$(echo $ligne | cut -d':' -f2)"
            nb_ligne=$nb_tot_ligne
        else 
            echo "The user $name is not registered."
        fi
    done < $file
    #TODO @Gylfirst - @zalk0 Il faut maintenant ajouter/réécrire les infos avec un read et à la bonne position
}

## COMMANDE DE TEST
# rsvh -admin
# rsvh -connect machine1 user
# rsvh -connect machine2 user
# rsvh -help
# rsvh dzq
# rhost
# finger user
# finger user1
# afinger
# host
# user
su user1