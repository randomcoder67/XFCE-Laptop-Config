#!/usr/bin/env bash

# Rofi script to launch applications and open files

## Add ~/.local/bin to $PATH
PATH=$PATH:$HOME/.local/bin

selection=$(cat ~/Programs/output/updated/files.txt | rofi -refilter-timeout-limit 16000 -kb-custom-1 "Shift+Return" -dmenu -show-icons -i -p "Launcher")
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
		if [[ "$selectedProgramName" == "mpv" ]]; then
			if [[ "$selection" == *".m4a" ]]; then
			mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection" || notify-send "Error, file format not supported"
			else
				mpv "$newSelection" || notify-send "Error, file format not supported"
			fi
		else
			"$selectedProgram" "$newSelection" || notify-send "Error, file format not supported"
		fi
	else
		if [[ "$selection" == *".m4a" ]]; then
			mpv --title='${metadata/title}'\ -\ '${metadata/artist}' "$newSelection"
		else
			xdg-open "$newSelection"
		fi
	fi
elif [[ $selection == "Wikipedia" ]]; then
	searchTerm=$(rofi -dmenu -p "Enter Search Term (Blank for homepage)") # Get search term from user
	if [[ "$searchTerm" == "" ]]; then # If blank, open main page
		firefox "https://en.wikipedia.org/wiki/Main_Page"
	else # Otherwise, use API to search
		finalSearchTerm=${searchTerm// /+} # Replace spaces with "+" for url
		# Get URL
		finalWikipediaURL=$(curl "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=$finalSearchTerm&format=json&srlimit=1" | jq .query.search[0].pageid)
		[[ "$finalWikipediaURL" == "" ]] || [[ "$finalWikipediaURL" == "null" ]] && notify-send "No Results Found" && exit # Check for errors
		# Open url with firefox
		firefox "https://en.wikipedia.org/w/index.php?curid=$finalWikipediaURL"
	fi
elif [[ $selection == "Terraria Wiki" ]]; then
	searchTerm=$(rofi -dmenu -p "Enter Search Term (Blank for homepage)") # Get search term from user
	if [[ "$searchTerm" == "" ]]; then # If blank, open main page
		firefox "https://terraria.wiki.gg/wiki/Terraria_Wiki"
	else # Otherwise, use API to search
		finalSearchTerm=${searchTerm// /+} # Replaces spaces with "+" for url
		# Get search results
		searchResults=$(curl "https://terraria.wiki.gg/api.php?action=query&format=json&errorformat=bc&prop=&list=search&srsearch=eye+of")
		# Present results to user and allow them to pick desired page
		result=$(echo $searchResults | jq .query.search.[].title -r | rofi -dmenu -p "Choose Page")
		urlString=${result// /_} # Replace spaces with "_" for url
		# Open url with firefox
		firefox "https://terraria.wiki.gg/wiki/$urlString"
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
elif [[ $selection == "Google Earth" ]]; then
	~/.local/bin/googleEarth/googleearth
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
	firefox "https://ridewithgps.com/routes/new"
elif [[ $selection == "ITVX" ]]; then
	firefox "https://www.itv.com"
elif [[ $selection == "FlightRadar24" ]]; then
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	firefox "https://www.flightradar24.com/${lat:0:5},${lon:0:5}/9"
elif [[ $selection == "GOverlay" ]]; then
	~/.local/bin/goverlay
elif [[ $selection == "NetHogs" ]]; then
	alacritty -e nethogs
elif [[ $selection == "Google Maps" ]]; then
	firefox "https://www.google.co.uk/maps"
elif [[ $selection == "cava" ]]; then
	alacritty -e "$HOME/.local/bin/cava"
elif [[ $selection == "Intel GPU Top" ]]; then
	alacritty -e sudo intel_gpu_top
elif [[ $selection == "Go Weather" ]]; then
	alacritty -e goWeather
elif [[ $selection == "pulsemixer" ]]; then
	alacritty -e pulsemixer
elif [[ $selection == "YouTube Subscriptions" ]]; then
	firefox "https://www.youtube.com/feed/subscriptions"
elif [[ $selection == "XColor Colour Picker" ]]; then
	xcolor | tr -d '\n' | tee >(xargs notify-send) | tr -d '#' | xclip -selection c
elif [[ "$selection" == "ZBar QR Code Scanner" ]]; then
	zbarcam -1 | sed 's/QR-Code://g' | tee >(xargs notify-send) | xclip -selection c
elif [[ "$selection" == "Discord" ]]; then
	firefox "https://discord.com/channels/@me"
elif [[ "$selection" == "Sudoku" ]]; then
	firefox "https://sudoku.com/"
elif [[ "$selection" == "Sunrise and Sunset" ]]; then
	firefox "https://www.timeanddate.com/sun/@$(cat $HOME/Programs/output/updated/curLocation.csv | tr "|" ",")"
elif [[ $selection == "Check All" ]]; then
	firefox "https://mail.google.com/mail/u/1" "https://mail.google.com/mail/u/2" "https://outlook.office.com/mail/" "https://github.com" "https://old.reddit.com" "https://stackoverflow.com/" "https://www.bbc.co.uk/news" "https://www.nasa.gov/multimedia/imagegallery/iotd.html" "https://twitter.com/destidarko?lang=en" "https://calendar.google.com/calendar/u/0/embed?src=i54j4cu9pl4270asok3mqgdrhk@group.calendar.google.com&pli=1" "https://twitter.com/home" "https://discord.com/channels/@me"
elif [[ -d ~/Videos/Media/$selection ]]; then # If a season of TV selected, get season and episode then play
	season=$(ls "$HOME/Videos/Media/$selection" | tr -d '/' | sed -n 's/Season\([0-9]*\)/\1\0/p' | sort -n | grep -Eo "Season[0-9]+" | rofi -dmenu -i -p "Select Season")
	episode=$(ls "$HOME/Videos/Media/$selection/$season" | tr -d '/' | sed -n 's/Episode\([0-9]*\).*/\1\0/p' | sort -n | grep -Eo "Episode[0-9]+" | rofi -dmenu -i -p "Select Episode")
	episodeNumA=${episode/Episode}
	episodeNum=${episodeNumA/.*}
	mpv --resume-playback '--title=${metadata/title} - S${metadata/season_number}E${metadata/episode_sort}' --playlist="$HOME/Videos/Media/$selection/$season" --playlist-start=$((episodeNum-1))
else
	${programs[$selection]}
fi
