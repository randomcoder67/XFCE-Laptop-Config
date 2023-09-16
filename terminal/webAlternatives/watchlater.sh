#!/usr/bin/env bash

# Script to display YouTube Watch Later playlist and allow playing of videos from it with mpv

# Get JSON of your Watch Later playlist (assumes you use firefox)
wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox "https://www.youtube.com/playlist?list=WL")

# Find number of entires, read urls into array and titles into array
numEntries=$(echo "$wcJSON" | jq '.entries | length')
urls=( $(echo "$wcJSON" | jq -r '.entries[].url') )
oldIFS="$IFS"
IFS=$'\n'
titles=( $(echo "$wcJSON" | jq -r '.entries[].title') )

# Create index and iterate through titles
index=1
for title in "${titles[@]}"; do
	liveUpcoming=""
	#if [ $(echo "$wcJSON" | jq -r .entries[$((index-1))].live_status) == "is_upcoming" ]; then
	#	liveUpcoming=" - (Live Upcoming)"
	#fi
	# Print the videos in format "index: title"
	echo "${index}: ${title}${liveUpcoming}"
	# Add one to index
	indexA=$((index+1))
	index=$indexA
done

# Get user selection, quit if q, blank or out of range
read -p "Enter video to watch (q to quit): " videoSelection
[[ "$videoSelection" == "q" ]] || [[ "$videoSelection" == "" ]] || ((videoSelection>index-1)) && exit

# Get real index and open video in mpv with correct title
realIndex=$((videoSelection-1))
mpv --title="${titles[$realIndex]}" --ytdl-format="best" "${urls[$realIndex]}" --really-quiet & disown
