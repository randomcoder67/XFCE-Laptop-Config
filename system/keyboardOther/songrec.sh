#!/usr/bin/env bash

notify-send "Listening to audio"
song=$(timeout 10s songrec recognize -d pulse)
if ! [[ "$song" == "" ]]; then
	notify-send "$song"
	time=$(date +"%y%m%d %H:%M")
	echo "$time $song" >> ~/Programs/output/updated/songs.txt
else
	notify-send "Failed to identify song"
fi
