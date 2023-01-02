#!bin/bash

mode=$1
user=$2
machine=$3

source verifications.sh 2 $machine $user
case $? in
    2 )
        echo "$machine doesn't exist";;
    4 ) 
        echo "You don't have access to $machine";;
    0 )
        source rvsh.sh rconnect
        prompt $mode $machine $user
        # syntax function ?
esac
