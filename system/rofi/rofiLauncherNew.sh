#!/usr/bin/env bash

# Rofi script to launch applications and open files

selection=$(cat ~/Programs/output/updated/files.txt | rofi -dmenu -show-icons -i -p "Launcher")

[[ "$selection" == "" ]] && exit

if [[ $selection == *".m4a" ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
elif [[ $selection == *"/"* ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	xdg-open "$newSelection"
elif [[ $selection == "~" ]]; then
	xdg-open "$selection"
else
	toRun=$(sed -n -e "s/^.*$selection;//p" ~/Programs/output/updated/programs.txt)
	$toRun
fi
