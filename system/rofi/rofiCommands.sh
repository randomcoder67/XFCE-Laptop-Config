#!/usr/bin/env bash

item=$(cat ~/Programs/output/updated/commandsArchive.txt | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -dmenu -i -p "Commands")
status=$?
if [ $status -eq 10 ]; then
	itemToAdd=$(rofi -dmenu -p "Enter New Command")
	if ! [[ $itemToAdd == "" ]]; then
		echo $itemToAdd >> ~/Programs/output/updated/commandsArchive.txt
	fi
elif [ $status -eq 11 ]; then
	itemA=${item//"|"/"[|]"}
	sed -i "\|^$itemA$|d" ~/Programs/output/updated/commandsArchive.txt
else
	echo $item | xclip -selection c
fi
