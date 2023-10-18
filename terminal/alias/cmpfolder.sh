#!/usr/bin/env bash

# Script to compare two folders to ensure they are byte for byte identical 

[ "$2" == "" ] && echo "Usage: ./cmpfolder.sh folder1 folder2" && exit

IFS=$'\n'
filesA=( $(find "$1" -type f | sort) )
filesB=( $(find "$2" -type f | sort) )

index=0
for fileA in "${filesA[@]}"; do
	fileToCmp="${filesB[index]}"
	indexA=$((index+1))
	index="$indexA"
	cmp "$fileA" "$fileToCmp"
done
