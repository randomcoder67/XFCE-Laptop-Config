#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
	/usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback "$HOME/Music/curPlaylist" & disown
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -type f | sort | grep -i "$2" | xargs -d '\n' /usr/bin/mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback & disown
fi
