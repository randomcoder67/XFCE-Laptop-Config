#!/usr/bin/env bash

# Script to play music 

# If no argument given, shuffle music from current playlist 
if [[ "$1" == "" ]]; then
	/usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/curPlaylist" & disown
# Shuffle music of a particular artist (or artists with | to delimit)
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -type f -maxdepth 1 | sort | grep -iE "$2" | xargs -d '\n' /usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --loop-playlist --no-resume-playback & disown
fi
