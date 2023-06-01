#!/usr/bin/env bash

# Finds matching files in home directory and opens using given program, presents options if more than one

IFS=$'\n'

program=$1

files=( $(find ~ -iname "$2"* -type f) )

if (( ${#files[@]} == 0 )); then
	exit
fi

if (( ${#files[@]} > 1 )); then
	index=1
	for x in "${files[@]}"; do
		echo $index: $x
		((index=index+1))
	done
	read -p "Select which file to display: " selection
	if [ "$selection" == "q" ]; then
		exit
	fi
	if [[ "$program" == "mpv" ]]; then
		$program --really-quiet "${files[$selection-1]}" & disown
	else
		$program "${files[$selection-1]}"
	fi
	else
	if [[ "$program" == "mpv" ]]; then
		$program --really-quiet "${files[0]}" & disown
	else
		$program "${files[0]}"
	fi
fi
