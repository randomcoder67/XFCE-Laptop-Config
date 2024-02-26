#!/usr/bin/env bash

# Script to provide easy linking of Markdown files together, Obsidian style, but in any text editor/interface

oldIFS="$IFS"
IFS=$'\n'

# Get results and form array
results=$(grep -ir --include=*.md "^# " "$HOME/Programs/website/content/")
resultsArray=( $results )

# Get selection, only presenting titles and returning index
selection=$(echo "$results" | awk -F ':# ' '{print $2}' | rofi -dmenu -i -p "Select File To Link" -format i)
[[ "$selection" == "" ]] && exit

# Type the selected file name only
xdotool type --delay 5 $(echo "${resultsArray[$selection]}" | awk -F ':# ' '{print $1}')
