#!/bin/bash

file="./logs"
echo "Connected users:"
while read ligne
do
    machine=$(echo $ligne | cut -d'-' -f1)
    user=$(echo $ligne | cut -d'-' -f2)
    date=$(echo $ligne | cut -d'-' -f3)
    terminal=$(echo $ligne | cut -d'-' -f4)
    echo $user $machine $date $terminal
done < $file