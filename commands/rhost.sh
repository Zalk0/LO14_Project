#!/bin/bash

file="./machines"
echo "List of connected machines in the network:"
while read ligne
do
	echo $ligne
done < $file
