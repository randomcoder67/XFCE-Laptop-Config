#!/usr/bin/env bash

# Rofi script to launch applications and open files

selection=$(cat ~/Programs/output/updated/files.txt | rofi -dmenu -show-icons -i -p "Launcher")

[[ "$selection" == "" ]] && exit

IFS=$'\n'

declare -A programs

programsA=( $(cat ~/Programs/output/updated/programs.txt) )

if (( ${#programsA[@]} == 0 )); then
	exit
fi

for x in "${programsA[@]}"; do
	first=${x%%;*}
	second=${x##*;}
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
	"~/Programs/otherPrograms/LosslessCut-linux-x64/losslesscut"
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
	firefox https://www.kick.com/destiny
elif [[ $selection == "Rumble - Destiny" ]]; then
	firefox https://rumble.com/c/Destiny
elif [[ $selection == "Twitter - Destiny" ]]; then
	firefox https://twitter.com/TheOmniLiberal
elif [[ $selection == "BBC News" ]]; then
	firefox https://www.bbc.co.uk/news
elif [[ $selection == "Chat - Destiny" ]]; then
	firefox https://www.destiny.gg/embed/chat
elif [[ $selection == "NASA Image of the Day" ]]; then
	firefox https://www.nasa.gov/multimedia/imagegallery/iotd.html
elif [[ $selection == "Dead Cells" ]]; then
	steam steam://rungameid/588650
elif [[ $selection == "Terraria" ]]; then
	"$HOME/.local/share/GOG/Games/Terraria/start.sh"
elif [[ $selection == "SHENZHEN IO" ]]; then
	"$HOME/.local/share/GOG/Games/SHENZHEN I O/start.sh"
elif [[ $selection == "Opus Magnum" ]]; then
	"$HOME/.local/share/GOG/Games/Opus Magnum/start.sh"
elif [[ $selection == "shapez" ]]; then
	steam steam://rungameid/1318690
elif [[ $selection == "Kerbal Space Program" ]]; then
	steam steam://rungameid/220200
elif [[ $selection == "Noita" ]]; then
	steam steam://rungameid/881100
elif [[ $selection == "Slime Rancher" ]]; then
	"$HOME/.local/share/GOG/Games/Slime Rancher/start.sh"
elif [[ $selection == "PCSX2" ]]; then
	"$HOME/.local/share/games/pcsx2.AppImage"
elif [[ $selection == "SimCity 4" ]]; then
	steam steam://rungameid/24780
elif [[ $selection == "RideWithGPS" ]]; then
	firefox "https://ridewithgps.com"
elif [[ $selection == "ITVX" ]]; then
	firefox "https://www.itv.com"
else
	${programs[$selection]}
fi
