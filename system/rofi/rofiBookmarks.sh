#!/usr/bin/env bash

# Script to present a Rofi window to the user and allow them to select a bookmark to copy or type

# Present the Rofi window to user, get the selected item and the return status (used to know which keys were pressed)
item=$(awk -F 'DELIM' '{print $1}' ~/Programs/output/updated/bookmarks.txt | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -kb-custom-3 "Shift+Return" -dmenu -i -p "Bookmarks")
status=$?

# status=10 means the user selected to add a bookmark
if [ $status -eq 10 ]; then
	# Get new bookmark to add
	itemToAdd=$(rofi -dmenu -p "Enter New Bookmark")
	[[ "$itemToAdd" == "" ]] && exit
	# Get alias for bookmark (will be blank if no alias is needed)
	itemAlias=$(rofi -dmenu -p "Enter Alias (Leave blank for no alias)")
	# Add bookmark with alias to file (if no alias specified, the bookmark and alias are the same
	if [[ "$itemAlias" == "" ]]; then
		echo "$itemToAdd""DELIM""$itemToAdd" >> ~/Programs/output/updated/bookmarks.txt
	else
		echo "$itemAlias""DELIM""$itemToAdd" >> ~/Programs/output/updated/bookmarks.txt
	fi
# status=11 means the user selected to remove a bookmark
elif [ $status -eq 11 ]; then
	# Get line number of match and remove it
	lineNum=$(grep -Fn "$item" ~/Programs/output/updated/bookmarks.txt | cut -d ":" -f 1)
	sed -i "${lineNum}d" ~/Programs/output/updated/bookmarks.txt
# status=12 means the user selected to open a bookmark in Firefox if possible
elif [ $status -eq 12 ]; then
	# keyup Shift as the shortcut is Shift+Return, this prevents the bookmark being typed as capital letters
	xdotool keyup Shift
	# Some string substitution to get correct format for grep
	itemA=$(echo "$item" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')
	# Finding bookmark from alias and check if url
	toOpen=$(grep "$itemA" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n')
	echo $toOpen
	if echo "$toOpen" | grep -q -E 'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'; then # If so, open it
		firefox "$toOpen"
	fi
# Otherwise the program returns with default status, meaning the user has selected to copy a bookmark
else
	# Some string substitution to get correct format for grep
	itemA=$(echo "$item" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')
	# Finding bookmark from alias and copy to clipboard
	grep "$itemA" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n' | xclip -selection c
fi
