#!/usr/bin/env bash

item=$(awk -F 'DELIM' '{print $1}' ~/Programs/output/updated/bookmarks.txt | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -kb-custom-3 "Shift+Return" -dmenu -i -p "Bookmarks")
status=$?
if [ $status -eq 10 ]; then
	itemToAdd=$(rofi -dmenu -p "Enter New Bookmark")
	[[ "$itemToAdd" == "" ]] && exit
	itemAlias=$(rofi -dmenu -p "Enter Alias (Leave blank for no alias)")
	if [[ "$itemAlias" == "" ]]; then
		echo "$itemToAdd""DELIM""$itemToAdd" >> ~/Programs/output/updated/bookmarks.txt
	else
		echo "$itemAlias""DELIM""$itemToAdd" >> ~/Programs/output/updated/bookmarks.txt
	fi
elif [ $status -eq 11 ]; then
	itemA=${item//"|"/"[|]"}
	itemA=${item//"\\"/"[\\]"}
	echo $itemA
	sed -i "\|^$itemA$|d" ~/Programs/output/updated/bookmarks.txt
elif [ $status -eq 12 ]; then
	#sleep 1
	xdotool keyup Shift
	itemA=$(echo "$item" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')
	toType=$(grep "$itemA" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n')
	xdotool type "$toType"
else
	itemA=$(echo "$item" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')
	grep "$itemA" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n' | xclip -selection c
fi
