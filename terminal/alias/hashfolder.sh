#!/usr/bin/env bash

# Script to get sha256/sha512 hashes of all files in a directory 

[ "$1" == "" ] && echo "Usage: ./hashfolder.sh folder" && exit


hash_command="sha256sum"
input_folder="$1"
if [[ "$1" == "-h" ]]; then
	echo "Usage: hashfolder [-l] folder/ (-l for sha512 instead of sha256)"
elif [[ "$1" == "-l" ]]; then
	hash_command="sha512sum"
	input_folder="$2"
fi

oldIFS="$IFS"
IFS=$'\n'
filesA=( $(find "$input_folder" -type f | sort) )
IFS="$oldIFS"

for fileA in "${filesA[@]}"; do
	"$hash_command" "$fileA"
done
