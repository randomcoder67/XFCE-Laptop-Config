#!/usr/bin/env bash

# Script to get sha256 hashes of all files in a directory 

IFS=$'\n'
filesA=( $(find "$1" -type f | sort) )

for fileA in "${filesA[@]}"; do
	sha256sum "$fileA"
done
