#!/usr/bin/env bash

# Script to display YouTube Watch Later playlist and allow playing of videos from it with mpv

wcJSON=$(yt-dlp -J --flat-playlist --cookies-from-browser firefox "https://www.youtube.com/playlist?list=WL")

numEntries=$(echo "$wcJSON" | jq '.entries | length')
urls=( $(echo "$wcJSON" | jq -r '.entries[].url') )
oldIFS="$IFS"
IFS=$'\n'
titles=( $(echo "$wcJSON" | jq -r '.entries[].title') )

index=1
for title in "${titles[@]}"; do
	liveUpcoming=""
	#if [ $(echo "$wcJSON" | jq -r .entries[$((index-1))].live_status) == "is_upcoming" ]; then
	#	liveUpcoming=" - (Live Upcoming)"
	#fi
	echo "${index}: ${title}${liveUpcoming}"
	indexA=$((index+1))
	index=$indexA
done

read -p "Enter video to watch (q to quit): " videoSelection
[[ "$videoSelection" == "q" ]] || [[ "$videoSelection" == "" ]] || ((videoSelection>index-1)) && exit

realIndex=$((videoSelection-1))
mpv --title="${titles[$realIndex]}" --ytdl-format="best" "${urls[$realIndex]}"
