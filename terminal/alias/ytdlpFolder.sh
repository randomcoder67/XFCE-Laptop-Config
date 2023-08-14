#!/usr/bin/env bash

# Get dir from which this script was called
rootDir=$(pwd)

oldIFS="$IFS"
IFS=$'\n'
# Read in list of playlists and folders to arrays 
videos=( $(cat "$1" | cut -d " " -f 1) )
folders=( $(cat "$1" | cut -d " " -f 2) )
index=0

for video in "${videos[@]}"; do
	cd "$rootDir"
	folder="${folders[$index]}"
	folderName="current"
	if [[ "$folder" == *"/"* ]]; then
		folderName="$folder"
		mkdir -p "$folder"
		cd "$folder"
	fi
	
	echo "Getting playlist information"
	playlistJSON=$(yt-dlp -J --flat-playlist --no-warnings "$video")
	playlistLength=$(echo "$playlistJSON" | jq '.entries | length')
	playlistTitle=$(echo "$playlistJSON" | jq -r .title)
	echo "Playlist: ""${playlistTitle}"", of length: "${playlistLength}", downloading to directory ""${folder}"
	
	# If "-l" argument given, limit yt-dlp aria2c to 3MB/s
	if [[ "$2" == "-l" ]]; then
		yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=3M" -o "%(title)s.%(ext)s" "$video"
	else
		yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M" -o "%(title)s.%(ext)s" "$video"
	fi
	
	indexA=$((index+1))
	index=$indexA
done
