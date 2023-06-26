#!/usr/bin/env bash

# Script to identify a song and save to a file with timestamp 

notify-send "Listening to audio"
# Listen for song with songrec, timeout of 10s incase the song can't be recognised
song=$(timeout 10s songrec recognize -d pulse)
if ! [[ "$song" == "" ]]; then
	notify-send "$song"
	time=$(date +"%y%m%d %H:%M")
	# Added to file with timestamp
	echo "$time $song" >> ~/Programs/output/updated/songs.txt
else
	notify-send "Failed to identify song"
fi
