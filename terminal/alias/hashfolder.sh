#!/usr/bin/env bash

# Script to get sha256/sha512 hashes of all files in a directory 

[ "$1" == "" ] && echo "Usage: ./hashfolder.sh folder" && exit

IFS=$'\n'

if [[ "$1" == "-h" ]]; then
	echo "Usage: hashfolder [-l] folder/ (-l for sha512 instead of sha256)"
elif [[ "$1" == "-l" ]]; then
	filesA=( $(find "$2" -type f | sort) )
	for fileA in "${filesA[@]}"; do
		sha512sum "$fileA"
	done
else
	filesA=( $(find "$1" -type f | sort) )
	for fileA in "${filesA[@]}"; do
		sha256sum "$fileA"
	done
fi
