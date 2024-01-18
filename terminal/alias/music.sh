#!/usr/bin/env bash

# Script to play music 

socketName=/tmp/mpv.playlist
favouritesDir="$HOME/Music/Favourites/"

# Music controls
if [[ "$1" == "--next" ]]; then
	echo "playlist-next" | socat - "$socketName"
	exit
elif [[ "$1" == "--prev" ]]; then
	echo "playlist-prev" | socat - "$socketName"
	exit
elif [[ "$1" == "--favourite" ]]; then
	currentlyPlaying=$(echo '{ "command": ["get_property", "path"] }' | socat - "$socketName" | jq .data -r)
	cp "$currentlyPlaying" "$favouritesDir"
	notify-send "Added song to favourites"
	exit
elif [[ "$1" == "--toggle-pause" ]]; then
	echo "cycle pause" | socat - "$socketName"
	exit
elif [[ "$1" == "--quit" ]]; then
	echo "quit" | socat - "$socketName"
	exit
fi

# Default to dummy arguments that basically do nothing
backgroundArg1="--pause=no"
backgroundArg2="--fullscreen=no"
doArg="$1"

if [[ "$1" == "--background" ]]; then
	backgroundArg1="--no-audio-display"
	backgroundArg2="--force-window=no"
	doArg=""
elif [[ "$2" == "--background" ]]; then
	backgroundArg1="--no-audio-display"
	backgroundArg2="--force-window=no"
fi

# Check if music is already playing
ps -ax | grep "/usr/bin/mpv --really-quiet --title=\${metadata/title} - \${metadata/artist} --shuffle --no-resume-playback --loop-playlist $HOME/Music/" | grep -vq "grep" && notify-send "Music already playing" && exit

# Check if headphones plugged in (works but too slow to use)
#if ! grep -A4 -i 'Headphone Playback Switch' /proc/asound/card0/codec#*  | grep "Amp-Out vals.*0x00 0x00" -q; then
#	notify-send "Headphones Unplugged"
#	exit
#fi

# If no argument given, shuffle music from current playlist
if [[ "$doArg" == "" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music/CurrentPlaylist" "$backgroundArg1" "$backgroundArg2" --input-ipc-server="$socketName" & disown
# Present choice of playlists
elif [[ "$doArg" == "--choice" ]]; then
	playlists="All Music"$'\n'"$(find $HOME/Music/ -maxdepth 1 -mindepth 1 -type d | sort | sed 's/\([^/]\)\([A-Z][a-z]\)/\1 \2/g' | sed 's/\([a-z]\)\([0-9]\)/\1 \2/g' | cut -d '/' -f 5)"
	result=$(echo -e "$playlists" | rofi -dmenu -i -p "Select Music To Play")
	folder=""
	if [[ "$result" == "" ]]; then
		exit
	elif [[ "$result" == "All Music" ]]; then
		folder="$HOME/Music"
	else
		folder="$HOME/Music/$(echo $result | sed 's/ //g')"
	fi
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$folder" "$backgroundArg1" "$backgroundArg2" --input-ipc-server="$socketName" & disown
# Shuffle music of a particular artist (or artists with | to delimit)
elif [[ "$doArg" == "-a" ]]; then
	find "$HOME/Music/" -maxdepth 1 -type f | sort | grep -iE ".*-.* $2 .*-.*" | xargs -d '\n' /usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --loop-playlist --no-resume-playback "$backgroundArg1" "$backgroundArg2" --input-ipc-server="$socketName" & disown
elif [[ "$doArg" == "-al" ]]; then
	/usr/bin/mpv --really-quiet --title='${metadata/title}'\ -\ '${metadata/artist}' --shuffle --no-resume-playback --loop-playlist "$HOME/Music" "$backgroundArg1" "$backgroundArg2" --input-ipc-server="$socketName" & disown
fi
