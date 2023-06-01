#!/usr/bin/env bash

# rofi character picker

IFS=$'\n'
toRofi=()

declare -A characters

files=( $(cat ~/Programs/output/updated/characters.txt) )

if (( ${#files[@]} == 0 )); then
	exit
fi

for x in "${files[@]}"; do
	first=$(echo "$x" | cut -d\; -f1)
	second=$(echo "$x" | cut -d\; -f2)
	toRofi+=("$first")
	characters["$first"]=$second
done

choice=$(printf "%s\n" "${toRofi[@]}" | rofi -dmenu -i -p "Select Character")
if [[ "$choice" == "" ]]; then
	exit
else
	echo -n "${characters["$choice"]}" | xclip -selection c
fi
