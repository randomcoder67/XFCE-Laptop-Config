#!/usr/bin/env bash

# Script to display YouTube Watch Later playlist and allow playing of videos from it with mpv

# Get JSON of your Watch Later playlist or Subscriptions (assumes you use firefox)
if [[ "$1" == "-s" ]]; then
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox --playlist-end 20 "https://www.youtube.com/feed/subscriptions")
else
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox "https://www.youtube.com/playlist?list=WL")
fi

# Find number of entires, read urls into array and titles into array
numEntries=$(echo "$wcJSON" | jq '.entries | length')
urls=( $(echo "$wcJSON" | jq -r '.entries[].url') )
oldIFS="$IFS"
IFS=$'\n'
titles=( $(echo "$wcJSON" | jq -r '.entries[].title') )
channels=( $(echo "$wcJSON" | jq -r '.entries[].channel') )
IFS="$oldIFS"
# Create index and iterate through titles
index=1
for title in "${titles[@]}"; do
	liveUpcoming=""
	#if [ $(echo "$wcJSON" | jq -r .entries[$((index-1))].live_status) == "is_upcoming" ]; then
	#	liveUpcoming=" - (Live Upcoming)"
	#fi
	# Print the videos in format "index: title"
	echo "${index}: ${title}${liveUpcoming} - ${channels[$((index-1))]}"
	# Add one to index
	indexA=$((index+1))
	index=$indexA
done

# Get user selection, quit if q, blank or out of range
read -p "Enter video to watch (q to quit): " videoSelection
[[ "$videoSelection" == "q" ]] || [[ "$videoSelection" == "" ]] || ((videoSelection>index-1)) && exit

# Make array out of user input
oldIFS="$IFS"
IFS=','
videos=( $(echo "$videoSelection") )
IFS="$oldIFS"

# Iterate through array and append selected videos to allVids variable
allVids=""
for video in "${videos[@]}"; do
	# Get real index and add video to argument
	realIndex=$((video-1))
	allVids="$allVids${urls[$realIndex]} "
done

# Launch mpv with allVids as the list of videos
mpv --title='${media-title}' --ytdl-format="best" $allVids --really-quiet & disown
