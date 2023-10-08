#!/usr/bin/env bash

# Script play videos from your YouTube history, subscriptions, Watch Later or other playlists with mpv

# Get JSON of your Watch Later playlist or Subscriptions (assumes you use firefox)
if [[ "$1" == "-s" ]]; then
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox --playlist-end 20 "https://www.youtube.com/feed/subscriptions" 2> /dev/null)
elif [[ "$1" == "-h" ]]; then
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox --playlist-end 100 "https://www.youtube.com/feed/history" 2> /dev/null)
elif [[ "$1" == "-p" ]]; then
	playlistsJSON=$(yt-dlp --flat-playlist -J --cookies-from-browser firefox "https://www.youtube.com/feed/library" 2> /dev/null)
	oldIFS="$IFS"
	IFS=$'\n'
	ids=( $(echo "$playlistsJSON" | jq -r '.entries[] | select(.ie_key=="YoutubeTab") | .id') )
	titles=( $(echo "$playlistsJSON" | jq -r '.entries[] | select(.ie_key=="YoutubeTab") | .title') )
	IFS="$oldIFS"
	index=1
	for title in "${titles[@]}"; do
		echo "${index}: ${title}"
		indexA=$((index+1))
		index=$indexA
	done
	read -p "Enter playlist to show (q to quit): " playlistSelection
	[[ "$playlistSelection" == "q" ]] || [[ "$playlistSelection" == "" ]] || ((playlistSelection>index-1)) && exit
	id="${ids[$((playlistSelection-1))]}"
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox "https://www.youtube.com/playlist?list=$id" 2> /dev/null)
else
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox "https://www.youtube.com/playlist?list=WL" 2> /dev/null)
fi

# Find number of entires, read urls into array and titles into array
urls=( $(echo "$wcJSON" | jq -r '.entries[] | select(.ie_key=="Youtube" and .channel!=null) | .url') )
# select(.url | contains("shorts") | not) would be the proper way, if they fix shorts having channel=null
oldIFS="$IFS"
IFS=$'\n'
titles=( $(echo "$wcJSON" | jq -r '.entries[] | select(.ie_key=="Youtube" and .channel!=null) | .title') )
channels=( $(echo "$wcJSON" | jq -r '.entries[] | select(.ie_key=="Youtube" and .channel!=null) | .channel') )
numEntries="${#titles[@]}"
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
