#!bin/bash

mode=$1
user=$2
machine=$3

case $user in
    "root" )
        source verifications.sh 0 $machine
        case $? in
            0 )
                source rvsh.sh rconnect
                prompt "connect" $machine $user;;
            2 )
                echo "$machine doesn't exist";;
            6 )
                echo "The machine name must only contain miniscule letters and digits"
        esac;;
    * )
        source verifications.sh 2 $machine $user
        case $? in
            0 )
                source rvsh.sh rconnect
                prompt $mode $machine $user;;
            2 )
                echo "$machine doesn't exist";;
            4 ) 
                echo "You don't have access to $machine";;
            6 )
                echo "The machine name must only contain miniscule letters and digits"
        esac
esac
