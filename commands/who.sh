#!/bin/bash

file="./logs"
echo "Connected users on $1:"
sed -n "/^$1/p" $file