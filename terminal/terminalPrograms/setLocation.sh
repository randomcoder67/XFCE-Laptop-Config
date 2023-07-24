#!/usr/bin/env bash

# Script to update current location (used for other programs)

curLocationFile="$HOME/Programs/output/updated/curLocation.csv"
savedLocationsFile="$HOME/Programs/output/updated/locations.csv"

getNewLocation () {
	firefox "https://www.openstreetmap.org/#map=8/55.396/-3.983" # Open map in firefox 
	read -n 1 -s # wait for keypress (-s = silent, -n 1 = one character (no enter needed))

	windowID=$(xdotool search --name "OpenStreetMap — Mozilla Firefox") # Get window ID 
	xdotool windowfocus "$windowID" # Focus 
	xdotool keydown Ctrl # Highlight address bar (Ctrl-l)
	xdotool key l
	xdotool keyup Ctrl
	sleep 0.1
	xdotool keydown Ctrl # Copy URL (Ctrl-c)
	xdotool key c
	xdotool keyup Ctrl
	sleep 0.1

	url=$(xclip -out -selection clipboard) # Get url 
	lat=$(echo "$url" | cut -d "/" -f 5) # Get lat
	lng=$(echo "$url" | cut -d "/" -f 6) # Get lng
	echo $lat, $lng
	echo "${lat}|${lng}" > $curLocationFile # Update curLocation.csv

	read -p "Enter Name to Save: " inputName # Ask for name 
	[[ "$inputName" == "" ]] && exit # If name is blank, exit
	echo "${inputName}|${lat}|${lng}" >> $savedLocationsFile # Otherwise save to file
}

# Main 

oldIFS="$IFS" # Save old IFS to restore later and change to \n as reading in file to array 
IFS=$'\n'
if test -e "$savedLocationsFile"; then # If saved location file exists, print it with indexes 
	locations=( $(cat $savedLocationsFile | cut -d "|" -f 1) )

	index=1
	for location in "${locations[@]}"; do
		echo "${index}: ${location}"
		indexA=$((index+1))
		index="$indexA"
	done

	read -p "Enter Index (or n to add new, q to quit): " inputIndex
else # Else print different prompt
	read -p "Enter Option (n to add new, q to quit): " inputIndex
fi

IFS="$oldIFS" # Restore IFS

if [[ "$inputIndex" == "" ]] || [[ "$inputIndex" == "q" ]]; then # If blank or q, exit 
	exit
elif [[ "$inputIndex" == "n" ]]; then # If n, add a new location
	getNewLocation
else
	re='^[0-9]+$'
	[[ "$inputIndex" =~ $re ]] || exit # If inputIndex is not a number, exit
	fileLength=$(cat $savedLocationsFile | wc -l)
	if (( inputIndex > fileLength )); then # Check index is in range 
		echo "Index out of range"
		exit
	else # Save selected location to curLocationFile
		cat $savedLocationsFile | sed -n "${inputIndex}p" | cut -d "|" -f 2-3 > $curLocationFile
	fi
fi
