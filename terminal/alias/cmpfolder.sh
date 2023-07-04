#!/usr/bin/env bash

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
