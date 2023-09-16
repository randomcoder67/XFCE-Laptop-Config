#!/usr/bin/env bash

# Script to find the total length of a YouTube playlist

# Get playlist data into an array (yt-dlp -j gives each video as a seperate JSON block)
oldIFS="$IFS"
IFS=$'\n'
playlistJSON=( $(yt-dlp -q -j --flat-playlist "$1" 2>/dev/null) )
IFS="$oldIFS"

# Add up duration
totalDuration=0
for entry in "${playlistJSON[@]}"; do
	videoDuration=$(echo $entry | jq .duration)
	totalDurationA=$((totalDuration+videoDuration))
	totalDuration=$totalDurationA
done

# Calculate hours, minutes and seconds
hours=$((totalDuration/3600))
minutes=$(( (totalDuration- (hours*3600) ) /60))
seconds=$((totalDuration- (hours*3600) - (minutes*60)))

# Display the result
echo "${hours}h, ${minutes}m, ${seconds}s"

#echo "$totalDuration" | awk '{hours=int($1/3600)} {minutes=int(($1-(hours*3600))/60)} {seconds=int($1-(hours*3600)-(minutes*60))} {printf("%dh, %dm, %ds\n", hours, minutes, seconds)}'
