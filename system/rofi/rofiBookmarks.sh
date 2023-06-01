#!/usr/bin/env bash

item=$(cat ~/Programs/output/updated/bookmarks.txt | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -dmenu -i -p "Bookmarks")
status=$?
if [ $status -eq 10 ]; then
	itemToAdd=$(rofi -dmenu -p "Enter New Bookmark")
	if ! [[ $itemToAdd == "" ]]; then
		echo $itemToAdd >> ~/Programs/output/updated/bookmarks.txt
	fi
elif [ $status -eq 11 ]; then
	itemA=${item//"|"/"[|]"}
	itemA=${item//"\\"/"[\\]"}
	echo a
	echo $itemA
	sed -i "\|^$itemA$|d" ~/Programs/output/updated/bookmarks.txt
else
	echo $item | xclip -selection c
fi
