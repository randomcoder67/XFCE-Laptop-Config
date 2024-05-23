#!/usr/bin/env bash

# Script play videos from your YouTube history, subscriptions, Watch Later or other playlists with mpv

LINE_RESET='\033[1A'
chars=("-" "\\" "|" "/")

# Get JSON of your Watch Later playlist or Subscriptions (assumes you use firefox)
if [[ "$1" == "-s" ]]; then
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox --playlist-end 20 "https://www.youtube.com/feed/subscriptions" 2> /dev/null)
elif [[ "$1" == "-h" ]]; then
	wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox --playlist-end 100 "https://www.youtube.com/feed/history" 2> /dev/null)
elif [[ "$1" == "-p" ]]; then
	playlistsJSON=$(yt-dlp --flat-playlist -J --cookies-from-browser firefox "https://www.youtube.com/feed/playlists" 2> /dev/null)
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
elif [[ "$1" != "" ]]; then
	echo "Error, incorrectly formatted arguments"
	echo "Usage:"
	echo "  wl - View watch later playlist"
	echo "  wl -h - View watch history"
	echo "  wl -s - View subscription feed"
	echo "  wl -p - View all saved/created playlists"
	exit
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
# Get size of terminal
length="$(tput cols)"
for title in "${titles[@]}"; do
	liveUpcoming=""
	#if [ $(echo "$wcJSON" | jq -r .entries[$((index-1))].live_status) == "is_upcoming" ]; then
	#	liveUpcoming=" - (Live Upcoming)"
	#fi
	# Print the videos in format "index: title"
	toPrint="${index}: ${title}${liveUpcoming} - ${channels[$((index-1))]}"
	
	printf -v _ %s%n "$toPrint" strLen
	
	if [[ "$strLen" -gt "$length" ]]; then
		echo "${toPrint:0:$((length-3))}..."
	else
		echo "$toPrint"
	fi
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

# Input a for all videos in playlist
if [[ "$videoSelection" == "a" ]]; then
	videos=()
	i=1
	for video in "${urls[@]}"; do
		videos+=($i)
		i=$((i+1))
	done
fi

# Iterate through array and append selected videos to allVids variable
allVids=""
for video in "${videos[@]}"; do
	# Get real index and add video to argument
	realIndex=$((video-1))
	allVids="$allVids${urls[$realIndex]} "
done

# Remove previous output file
[ -f /tmp/mpv.out ] && rm /tmp/mpv.out
# Launch mpv with allVids as the list of videos
mpv --title='${media-title}' --ytdl-format="best" --ytdl-raw-options=mark-watched=,cookies-from-browser=firefox $allVids 2> /dev/null | sed -u '/Resuming playback/d' | sed -u '/Playing/d' >> /tmp/mpv.out & disown

# Check every 0.2 seconds if the command if the video is open yet, if it's not, print loading text
i=0
echo ""
while [[ "$(cat /tmp/mpv.out)" == "" ]]; do
	echo -ne "${LINE_RESET}Loading ${chars[$((i%4))]}           \n"
	i=$((i+1))
	sleep 0.2
done
