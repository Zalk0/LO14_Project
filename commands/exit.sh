#!/bin/bash

user=$1
machine=$2
file="./logs"
temp="./temp"

sed '/'$machine'-'$user'/d' $file > $temp
mv $temp $file
rm -f $temp
break