#!/usr/bin/env bash

# Script to play music 

socketName=/tmp/mpv.playlist

# Music controls
if [[ "$1" == "--next" ]]; then
	echo playlist-next | socat - "$socketName"
	exit
elif [[ "$1" == "--prev" ]]; then
	echo playlist-prev | socat - "$socketName"
	exit
fi

# Check if music is already playing
ps -ax | grep "/usr/bin/mpv --really-quiet --title=\${metadata/title} - \${metadata/artist} --shuffle --no-resume-playback --loop-playlist $HOME/Music/" | grep -vq "grep" && notify-send "Music already playing" && exit

# If no argument given, shuffle music from current playlist 
if [[ "$1" == "" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/curPlaylist" --input-ipc-server="$socketName" & disown
# Shuffle music of a particular artist (or artists with | to delimit)
elif [[ "$1" == "-a" ]]; then
	find "$HOME/Music/" -maxdepth 1 -type f | sort | grep -iE ".*-.* $2 .*-.*" | xargs -d '\n' /usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --loop-playlist --no-resume-playback --input-ipc-server="$socketName" & disown
elif [[ "$1" == "-al" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music" --input-ipc-server="$socketName" & disown
fi
