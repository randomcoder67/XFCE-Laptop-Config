#!/usr/bin/env bash

song=$(timeout 20s songrec recognize -d pulse)
if ! [[ "$song" == "" ]]; then
	notify-send "$song"
	time=$(date +"%y%m%d %H:%M")
	echo "$time: $song" >> ~/Programs/output/updated/songs.txt
fi
