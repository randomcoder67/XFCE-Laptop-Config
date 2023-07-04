#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
	/usr/bin/mpv --shuffle "$HOME/Music/curPlaylist" & disown
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -type f | sort | grep -i "$2" | xargs -d '\n' /usr/bin/mpv --shuffle & disown
fi
