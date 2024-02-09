#!/usr/bin/env bash

# Script to present a Rofi window to the user and allow them to select a bookmark to copy or type

# Present the Rofi window to user, get the selected item and the return status (used to know which keys were pressed)
index=$("$HOME/Programs/output/updated/bookmarksIcons.sh" | rofi -kb-custom-1 "Ctrl+a" -kb-custom-2 "Ctrl+w" -kb-custom-3 "Shift+Return" -dmenu -show-icons -i -format "d" -p "Bookmarks")
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
	"$HOME/Programs/system/rofi/addIconsBookmarks.sh"
# status=11 means the user selected to remove a bookmark
elif [ $status -eq 11 ]; then
	# Get line number of match and remove it
	sed -i "${index}d" ~/Programs/output/updated/bookmarks.txt
	"$HOME/Programs/system/rofi/addIconsBookmarks.sh"
# status=12 means the user selected to open a bookmark in Firefox if possible
elif [ $status -eq 12 ]; then
	# keyup Shift as the shortcut is Shift+Return, this prevents the bookmark being typed as capital letters
	xdotool keyup Shift
	# Get bookmark, remove alias and check if url
	toOpen=$(sed "${index}q;d" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n')
	if echo "$toOpen" | grep -q -E 'https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)'; then # If so, open it
		firefox "$toOpen"
	else
		notify-send "Not a URL"
	fi
# Otherwise the program returns with default status, meaning the user has selected to copy a bookmark
else
	# Get bookmark, remove alias and copy to clipboard
	sed "${index}q;d" ~/Programs/output/updated/bookmarks.txt | awk -F 'DELIM' '{print $2}' | tr -d '\n' | xclip -selection c
fi
