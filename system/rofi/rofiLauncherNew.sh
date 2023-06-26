#!/usr/bin/env bash

# Rofi script to launch applications and open files

# Present Rofi window to user and get selection
selection=$(cat ~/Programs/output/updated/files.txt | rofi -dmenu -show-icons -i -p "Launcher")

[[ "$selection" == "" ]] && exit

if [[ $selection == *".m4a" ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
# If the selection is a file, use xdg-open to open in default application
elif [[ $selection == *"/"* ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	xdg-open "$newSelection"
elif [[ $selection == "~" ]]; then
	xdg-open "$selection"
# Else open the program/run the command (works with multiple arguments)
else
	toRun=$(sed -n -e "s/^.*$selection;//p" ~/Programs/output/updated/programs.txt)
	$toRun
fi
