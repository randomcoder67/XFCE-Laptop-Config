#!/usr/bin/env bash

IFS=$'\n'
filesA=( $(find "$1" -type f | sort) )

for fileA in "${filesA[@]}"; do
	sha256sum "$fileA"
done
