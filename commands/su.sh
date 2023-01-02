#!/bin/bash

machine=$1
user=$2

if [[ $user == "admin" ]] || [[ $user == "root" ]]; then
	source rvsh.sh "-admin"
else
	source rvsh.sh "-connect" $1 $2
fi
