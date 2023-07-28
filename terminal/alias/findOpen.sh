#!/usr/bin/env bash

# Finds matching files in home directory and opens using given program, presents options if more than one

IFS=$'\n'

program=$1
[[ "$2" == "" ]] && exit

files=( $(find ~ -iname "$2"* -type f) )

# Exit if not matches found 
if (( ${#files[@]} == 0 )); then
	exit
fi

if (( ${#files[@]} > 1 )); then
	index=1
	# Display options with index 
	for x in "${files[@]}"; do
		echo $index: $x
		((index=index+1))
	done
	# Read in user selection and open (or quit if q)
	read -p "Select which file to display: " selection
	if [ "$selection" == "q" ]; then
		exit
	fi
	if [[ "$program" == "mpv" ]]; then
		$program --really-quiet "${files[$selection-1]}" & disown
	else
		$program "${files[$selection-1]}"
	fi
# If only one match found, don't present options, just open it
else
	if [[ "$program" == "mpv" ]]; then
		$program --really-quiet "${files[0]}" & disown 
	else
		$program "${files[0]}"
	fi
fi
