#!/usr/bin/env bash

# Rofi script to launch applications and open files

selection=$(cat ~/Programs/output/updated/files.txt | rofi -dmenu -show-icons -i -p "Launcher")

IFS=$'\n'

declare -A programs

programsA=( $(cat ~/Programs/output/updated/programs.txt) )

if (( ${#programsA[@]} == 0 )); then
	exit
fi

for x in "${programsA[@]}"; do
	first=$(echo "$x" | cut -d\; -f1)
	second=$(echo "$x" | cut -d\; -f2)
	programs["$first"]=$second
done

if [[ $selection == *".m4a" ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
elif [[ $selection == *"/"* ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	xdg-open "$newSelection"
elif [[ $selection == "~" ]]; then
	xdg-open "$selection"
elif [[ $selection == "btop" ]]; then
	alacritty -e btop
elif [[ $selection == "htop" ]]; then
	alacritty -e htop
elif [[ $selection == "Lossless Cut" ]]; then
	~/Programs/otherPrograms/LosslessCut-linux-x64/losslesscut
elif [[ $selection == "Mousepad" ]]; then
	mousepad -o window
elif [[ $selection == "mpv" ]]; then
	mpv --player-operation-mode=pseudo-gui
elif [[ $selection == "qalc" ]]; then
	alacritty -e qalc
elif [[ $selection == "LibreOffice Writer" ]]; then
	libreoffice --writer
elif [[ "$selection" == "Shuffle Playlist" ]]; then
	mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --geometry=25% --shuffle --no-resume-playback "~/Music/currentPlaylist"
elif [[ $selection == "Kick - Destiny" ]]; then
	firefox www.kick.com/destiny
elif [[ $selection == "Rumble - Destiny" ]]; then
	firefox https://rumble.com/c/Destiny
elif [[ $selection == "Twitter - Destiny" ]]; then
	firefox https://twitter.com/TheOmniLiberal
else
	${programs[$selection]}
fi
