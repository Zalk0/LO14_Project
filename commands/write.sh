#!/bin/bash

names=$1
message=$2

user_name=$(echo $names | cut -d'@' -f1)
machine_name=$(echo $names | cut -d'@' -f2)
