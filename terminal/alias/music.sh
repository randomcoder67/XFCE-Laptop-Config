#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
	/usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/curPlaylist" & disown
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -type f -maxdepth 1 | sort | grep -iE "$2" | xargs -d '\n' /usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --loop-playlist --no-resume-playback & disown
fi
