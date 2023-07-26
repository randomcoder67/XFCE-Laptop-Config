#!/usr/bin/env bash

# Rofi script to launch applications and open files

selection=$(cat ~/Programs/output/updated/files.txt | rofi -kb-custom-1 "Shift+Return" -dmenu -show-icons -i -p "Launcher")
status=$?

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

if [[ $selection == *"/"* ]]; then
	newSelection=$(echo $selection | sed 's|~|'"${HOME}"'|g')
	if [ $status -eq 10 ]; then
		selectedProgramName=$(~/Programs/output/updated/launchersIcons.sh | rofi -dmenu -show-icons -i -p "Select Which Program to Use")
		selectedProgram=${programs[$selectedProgramName]}
		if [[ "$selectedProgram" == "mpv" ]] && [[ "$selection" == *".m4a" ]]; then
			mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
		else
			"$selectedProgram" "$newSelection"
		fi
	else
		if [[ "$selection" == *".m4a" ]]; then
			mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
		else
			xdg-open "$newSelection"
		fi
	fi
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
	"$HOME/.local/share/GOG/Terraria/start.sh"
elif [[ $selection == "SHENZHEN IO" ]]; then
	"$HOME/.local/share/GOG/SHENZHEN I O/start.sh"
elif [[ $selection == "Opus Magnum" ]]; then
	"$HOME/.local/share/GOG/Opus Magnum/start.sh"
elif [[ $selection == "shapez" ]]; then
	steam steam://rungameid/1318690
elif [[ $selection == "Kerbal Space Program" ]]; then
	steam steam://rungameid/220200
elif [[ $selection == "Euro Truck Simulator 2" ]]; then
	steam steam://rungameid/227300
elif [[ $selection == "American Truck Simulator" ]]; then
	steam steam://rungameid/270880
elif [[ $selection == "Noita" ]]; then
	steam steam://rungameid/881100
elif [[ $selection == "F1 2014" ]]; then
	steam steam://rungameid/226580
elif [[ $selection == "Slime Rancher" ]]; then
	"$HOME/.local/share/GOG/Slime Rancher/start.sh"
elif [[ $selection == "PCSX2" ]]; then
	"$HOME/.local/share/games/pcsx2.AppImage"
elif [[ $selection == "SimCity 4" ]]; then
	steam steam://rungameid/24780
elif [[ $selection == "RideWithGPS" ]]; then
	firefox "https://ridewithgps.com"
elif [[ $selection == "ITVX" ]]; then
	firefox "https://www.itv.com"
elif [[ $selection == "GOverlay" ]]; then
	~/.local/bin/goverlay
else
	${programs[$selection]}
fi
