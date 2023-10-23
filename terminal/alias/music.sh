#!/usr/bin/env bash

# Script to play music 

# If no argument given, shuffle music from current playlist 
if [[ "$1" == "" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/curPlaylist" & disown
# Shuffle music of a particular artist (or artists with | to delimit)
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -maxdepth 1 -type f | sort | grep -iE ".*-.* $2 .*-.*" | xargs -d '\n' /usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --loop-playlist --no-resume-playback & disown
elif [[ "$1" == "-al" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music" & disown
elif [[ "$1" == "-l" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/loudPlaylist" & disown
fi
