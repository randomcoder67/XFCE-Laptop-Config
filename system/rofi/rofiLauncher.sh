#!/usr/bin/env bash

# Rofi script to launch applications and open files

# Run checkfiles
#one="$(date +%s%N | cut -b1-13)"
#~/Programs/system/rofi/checkFiles.sh
#two="$(date +%s%N | cut -b1-13)"
#echo $(($two-$one))

## Add ~/.local/bin to $PATH
PATH=$PATH:$HOME/.local/bin

selection=$(cat ~/Programs/output/updated/files.txt | rofi -refilter-timeout-limit 18000 -kb-custom-1 "Shift+Return" -dmenu -show-icons -i -p "Launcher")
status=$?

[[ "$status" == 1 ]] && exit

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

wikiSearch () {
	apiAddress="$1"
	pageAddress="$2"
	mainPage="$3"
	wikiName="$4"
	
	searchTerm=$(rofi -dmenu -p "Enter Search Term (Blank for homepage)") # Get search term from user
	
	[[ "$?" == "1" ]] && exit
	
	if [[ "$searchTerm" == "" ]]; then # If blank, open main page
		firefox "$mainPage"
	else # Otherwise, use API to search
		finalSearchTerm=${searchTerm// /+} # Replaces spaces with "+" for url
		searchResults=$(curl "${apiAddress}action=query&format=json&errorformat=bc&prop=&list=search&srsearch=$finalSearchTerm")
		# Present results to user and allow them to pick desired page
		result=$(echo $searchResults | jq .query.search.[].title -r | rofi -dmenu -i -p "Choose Page")
		[[ "$?" == "1" ]] && exit
		if [[ "$result" != "" ]]; then
			urlString=${result// /_} # Replace spaces with "_" for url
			firefox "${pageAddress}${urlString}"
		fi
	fi
}

openMetOfficeCurLocation () {
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	geohash=$("$HOME/Programs/system/rofi/metoffice-geohash" "$lat" "$lon" "12")
	firefox "https://www.metoffice.gov.uk/weather/forecast/${geohash}"
}

openMetOfficeObservations () {
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	geohash=$("$HOME/Programs/system/rofi/metoffice-geohash" "$lat" "$lon" "12")
	firefox "https://www.metoffice.gov.uk/weather/observations/${geohash}"
}
	

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
elif [[ "$selection" == "Streamers" ]]; then
	# Read in list of streamers
	oldIFS="$IFS"
	IFS=$'\n'
	streamers=( $(cat "$HOME/Programs/output/updated/streamers.txt") )
	IFS="$oldIFS"
	numStreamers=$((${#streamers[@]}/3))
	
	# Generate rofi string and list of options
	toRun=()
	toOffer=""
	for i in $(seq 0 $((numStreamers-1))); do
		offset=$((i*3))
		channelName="${streamers[$offset]}"
		youtubeChannelAt="${streamers[$((offset+1))]}"
		twitchAt="${streamers[$((offset+2))]}"
		
		if [[ "$youtubeChannelAt" != "NONE" ]]; then
			toRun+=("YouTube")
			toRun+=("${channelName}")
			toRun+=("${youtubeChannelAt}")
			toOffer="${toOffer}${channelName} (YouTube)"$'\n'
		fi
		if [[ "$twitchAt" != "NONE" ]]; then
			toRun+=("Twitch")
			toRun+=("${channelName}")
			toRun+=("${twitchAt}")
			toOffer="${toOffer}${channelName} (Twitch)"$'\n'
		fi
	done
	
	# Get choice from user
	choiceNum=$(echo "$toOffer" | rofi -dmenu -format "i" -i -p "Select Stream")
	status="$?"
	[[ "$status" == 1 ]] && exit
	# Get offset and paramaters for streamLauncher.sh
	offset=$((3*choiceNum))
	platform="${toRun[$offset]}"
	channelName="${toRun[$((offset+1))]}"
	channelAt="${toRun[$((offset+2))]}"
	# Launch Stream
	"$HOME/Programs/system/panel/streamLauncher.sh" "$platform" "$channelName" "$channelAt"
elif [[ "$selection" == "Wikipedia" ]]; then
	wikiSearch "https://en.wikipedia.org/w/api.php?" "https://en.wikipedia.org/wiki/" "https://en.wikipedia.org/wiki/Main_Page" "Wikipedia"
elif [[ "$selection" == "Terraria Wiki" ]]; then
	wikiSearch "https://terraria.wiki.gg/api.php?" "https://terraria.wiki.gg/wiki/" "https://terraria.wiki.gg/wiki/Terraria_Wiki" "Terraria Wiki"
elif [[ "$selection" == "Minecraft Wiki" ]]; then
	wikiSearch "https://minecraft.wiki/api.php?" "https://minecraft.wiki/wiki/" "https://minecraft.wiki/" "Minecraft Wiki"
elif [[ "$selection" == "Kerbal Space Program Wiki" ]]; then
	wikiSearch "https://wiki.kerbalspaceprogram.com/api.php?" "https://wiki.kerbalspaceprogram.com/wiki/" "https://wiki.kerbalspaceprogram.com/wiki/Main_Page" "Kerbal Space Program Wiki"
elif [[ "$selection" == "Dead Cells Wiki" ]]; then
	wikiSearch "https://deadcells.wiki.gg/api.php?" "https://deadcells.wiki.gg/wiki/" "https://deadcells.wiki.gg/wiki/Dead_Cells_Wiki" "Dead Cells Wiki"
elif [[ "$selection" == "StarSector Wiki" ]]; then
	wikiSearch "https://starsector.fandom.com/api.php?" "https://starsector.fandom.com/wiki/" "https://starsector.fandom.com/wiki/Starsector_Wiki" "StarSector Wiki"
elif [[ "$selection" == "Surviving Mars Wiki" ]]; then
	wikiSearch "https://survivingmars.paradoxwikis.com/api.php?" "https://survivingmars.paradoxwikis.com/" "https://survivingmars.paradoxwikis.com/Surviving_Mars_Wiki" "Surviving Mars Wiki"
elif [[ "$selection" == "Timberborn Wiki" ]]; then
	wikiSearch "https://timberborn.wiki.gg/api.php?" "https://timberborn.wiki.gg/wiki/" "https://timberborn.wiki.gg/wiki/Timberborn_Wiki" "Timberborn Wiki"
elif [[ "$selection" == "Anno 1800 Wiki" ]]; then
	wikiSearch "https://anno1800.fandom.com/api.php?" "https://anno1800.fandom.com/wiki/" "https://anno1800.fandom.com/wiki/Anno_1800_Wiki" "Anno 1800 Wiki"
elif [[ "$selection" == "Children of Morta Wiki" ]]; then
	wikiSearch "https://childrenofmorta.fandom.com/api.php?" "https://childrenofmorta.fandom.com/wiki/" "https://childrenofmorta.fandom.com/wiki/Children_Of_Morta_Wiki" "Children of Morta Wiki"
elif [[ "$selection" == "Project Zomboid Wiki" ]]; then
	wikiSearch "https://pzwiki.net/api.php?" "https://pzwiki.net/wiki/" "https://pzwiki.net/wiki/Project_Zomboid_Wiki" "Project Zomboid Wiki"
elif [[ "$selection" == "Space Engineers Wiki" ]]; then
	wikiSearch "https://spaceengineers.fandom.com/api.php?" "https://spaceengineers.fandom.com/wiki/" "https://spaceengineers.fandom.com/wiki/Space_Engineers_Wiki" "Space Engineers Wiki"
elif [[ "$selection" == "Noita Wiki" ]]; then
	wikiSearch "https://noita.wiki.gg/api.php?" "https://noita.wiki.gg/wiki/" "https://noita.wiki.gg/wiki/Noita_Wiki" "Noita Wiki"
elif [[ "$selection" == "Mario Wiki" ]]; then
	wikiSearch "https://www.mariowiki.com/api.php?" "https://www.mariowiki.com/" "https://www.mariowiki.com/" "Mario Wiki"
elif [[ "$selection" == "CrossCode Wiki" ]]; then
	wikiSearch "https://crosscode.fandom.com/api.php?" "https://crosscode.fandom.com/wiki/" "https://crosscode.fandom.com/wiki/CrossCode_Wiki" "CrossCode Wiki"
elif [[ "$selection" == "No Man's Sky Wiki" ]]; then
	wikiSearch "https://nomanssky.fandom.com/api.php?" "https://nomanssky.fandom.com/wiki/" "https://nomanssky.fandom.com/wiki/No_Man%27s_Sky_Wiki" "No Man's Sky Wiki"
elif [[ "$selection" == "Forza Wiki" ]]; then
	wikiSearch "https://forza.fandom.com/api.php?" "https://forza.fandom.com/wiki/" "https://forza.fandom.com/wiki/Forza_Wiki" "Forza Wiki"
elif [[ "$selection" == "Dragons's Dogma Wiki" ]]; then
	wikiSearch "https://dragonsdogma.fandom.com/api.php?" "https://dragonsdogma.fandom.com/wiki/" "https://dragonsdogma.fandom.com/wiki/Dragon%27s_Dogma_Wiki" "Dragons's Dogma Wiki"
elif [[ "$selection" == "Internet Archive" ]]; then
	url=$(rofi -dmenu -p "Enter URL to find archives of")
	firefox "https://web.archive.org/web/*/$url"
elif [[ "$selection" == "~" ]]; then
	xdg-open "$selection"
elif [[ "$selection" == "btop" ]]; then
	alacritty -o 'window.title="btop"' -e btop
elif [[ "$selection" == "htop" ]]; then
	alacritty -o 'window.title="htop"' -e htop
elif [[ "$selection" == "Lossless Cut" ]]; then
	"~/Programs/otherPrograms/LosslessCut-linux-x64/losslesscut"
elif [[ "$selection" == "Mousepad" ]]; then
	mousepad -o window
elif [[ "$selection" == "mpv" ]]; then
	mpv --player-operation-mode=pseudo-gui
elif [[ "$selection" == "qalc" ]]; then
	alacritty -o 'window.title="qalc"' -e qalc
elif [[ "$selection" == "LibreOffice Writer" ]]; then
	libreoffice --writer
elif [[ "$selection" == "Google Earth" ]]; then
	~/Downloads/GoogleEarthPro/googleearthFull/googleearth
elif [[ "$selection" == "Shuffle Playlist" ]]; then
	mpv --title='${metadata/title}'\ -\ '${metadata/artist}' --geometry=25% --shuffle --no-resume-playback "~/Music/currentPlaylist"
elif [[ "$selection" == "Kick - Destiny" ]]; then
	firefox https://www.kick.com/destiny
elif [[ "$selection" == "Rumble - Destiny" ]]; then
	firefox https://rumble.com/c/Destiny
elif [[ "$selection" == "Twitter - Destiny" ]]; then
	firefox https://twitter.com/TheOmniLiberal
elif [[ "$selection" == "BBC News" ]]; then
	firefox https://www.bbc.co.uk/news
elif [[ "$selection" == "Chat - Destiny" ]]; then
	firefox https://www.destiny.gg/embed/chat
elif [[ "$selection" == "NASA Image of the Day" ]]; then
	firefox https://www.nasa.gov/multimedia/imagegallery/iotd.html
elif [[ "$selection" == "ChatGPT" ]]; then
	firefox "https://chat.openai.com"
elif [[ "$selection" == "Bard" ]]; then
	firefox "https://bard.google.com/chat"
elif [[ "$selection" == "Dead Cells" ]]; then
	steam steam://rungameid/588650
elif [[ "$selection" == "Terraria" ]]; then
	"$HOME/.local/share/GOG/Terraria/start.sh"
elif [[ "$selection" == "SHENZHEN IO" ]]; then
	"$HOME/.local/share/GOG/SHENZHEN I O/start.sh"
elif [[ "$selection" == "Opus Magnum" ]]; then
	"$HOME/.local/share/GOG/Opus Magnum/start.sh"
elif [[ "$selection" == "shapez" ]]; then
	steam steam://rungameid/1318690
elif [[ "$selection" == "Kerbal Space Program" ]]; then
	steam steam://rungameid/220200
elif [[ "$selection" == "Euro Truck Simulator 2" ]]; then
	steam steam://rungameid/227300
elif [[ "$selection" == "American Truck Simulator" ]]; then
	steam steam://rungameid/270880
elif [[ "$selection" == "Age of Empires II: HD Edition" ]]; then
	steam steam://rungameid/221380
elif [[ "$selection" == "Age of Empires II: Definitive Edition" ]]; then
	steam steam://rungameid/813780
elif [[ "$selection" == "Fallout 4" ]]; then
	steam steam://rungameid/377160
elif [[ "$selection" == "Horizon Zero Dawn" ]]; then
	steam steam://rungameid/1151640
elif [[ "$selection" == "Star Wars Empire at War" ]]; then
	steam steam://rungameid/32470
elif [[ "$selection" == "Noita" ]]; then
	steam steam://rungameid/881100
elif [[ "$selection" == "F1 2014" ]]; then
	steam steam://rungameid/226580
elif [[ "$selection" == "Project Cars 2" ]]; then
	steam steam://rungameid/378860
elif [[ "$selection" == "RimWorld" ]]; then
	steam steam://rungameid/294100
elif [[ "$selection" == "Stellaris" ]]; then
	steam steam://rungameid/281990
elif [[ "$selection" == "Dead Cells" ]]; then
	steam steam://rungameid/588650
elif [[ "$selection" == "BeamNG.drive" ]]; then
	steam steam://rungameid/284160
elif [[ "$selection" == "Slime Rancher" ]]; then
	"$HOME/.local/share/GOG/Slime Rancher/start.sh"
elif [[ "$selection" == "PCSX2" ]]; then
	"$HOME/.local/share/games/pcsx2.AppImage"
elif [[ "$selection" == "SimCity 4" ]]; then
	steam steam://rungameid/24780
elif [[ "$selection" == "RideWithGPS" ]]; then
	firefox "https://ridewithgps.com/routes/new"
elif [[ "$selection" == "ITVX" ]]; then
	firefox "https://www.itv.com"
elif [[ "$selection" == "VSCode" ]]; then
	"$HOME/Downloads/VSCode-linux-x64/bin/code"
elif [[ "$selection" == "FlightRadar24" ]]; then
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	firefox "https://www.flightradar24.com/${lat:0:5},${lon:0:5}/9"
elif [[ "$selection" == "NetHogs" ]]; then
	alacritty -o 'window.title="nethogs"' -e nethogs
elif [[ "$selection" == "Google Maps" ]]; then
	firefox "https://www.google.co.uk/maps"
elif [[ "$selection" == "cava" ]]; then
	alacritty -e "$HOME/.local/bin/cava"
elif [[ "$selection" == "Intel GPU Top" ]]; then
	alacritty -o 'window.title="intel-gpu-top"' -e sudo intel_gpu_top
elif [[ "$selection" == "Go Weather" ]]; then
	alacritty -o 'window.title="GoWeather"' -e goWeather
elif [[ "$selection" == "Play Music" ]]; then
	"$HOME/Programs/terminal/alias/music.sh" --choice
elif [[ "$selection" == "pulsemixer" ]]; then
	alacritty -o 'window.title="pulsemixer"' -e pulsemixer
elif [[ "$selection" == "Soundboard" ]]; then
	alacritty -o "window.dimensions.lines=26" -o "window.dimensions.columns=24" -o "window.title=Soundboard" -e "$HOME/Programs/system/keyboardOther/soundboard"
elif [[ "$selection" == "GoTube" ]]; then
	alacritty -o 'window.title="GoTube"' -e gotube
elif [[ "$selection" == "YouTube Subscriptions" ]]; then
	alacritty -o 'window.title="GoTube"' -e gotube --subscriptions
elif [[ "$selection" == "XColor Colour Picker" ]]; then
	xcolor | tr -d '\n' | tee >(xargs notify-send) | tr -d '#' | xclip -selection c
elif [[ "$selection" == "ZBar QR Code Scanner" ]]; then
	zbarcam -1 | sed 's/QR-Code://g' | tee >(xargs notify-send) | xclip -selection c
elif [[ "$selection" == "Discord" ]]; then
	firefox "https://discord.com/channels/@me"
elif [[ "$selection" == "Sudoku" ]]; then
	firefox "https://sudoku.com/"
elif [[ "$selection" == "Geocaching" ]]; then
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	firefox "https://www.geocaching.com/play/map?lat=${lat:0:5}&lng=${lon:0:5}&zoom=13&asc=true&sort=distance&st=N+56%C2%B0+20.003%27+W+2%C2%B0+47.058%27&ot=coords"
elif [[ "$selection" == "Munzee" ]]; then
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	geohash=$("$HOME/Programs/system/rofi/metoffice-geohash" "$lat" "$lon" "9")
	firefox "https://www.munzee.com/map/${geohash}/13"
elif [[ "$selection" == "OS Maps" ]]; then
	lat=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 1)
	lon=$(cat $HOME/Programs/output/updated/curLocation.csv | cut -d "|" -f 2)
	firefox "https://explore.osmaps.com/?lat=${lat}&lon=${lon}&zoom=11.5&style=Leisure&type=2d"
elif [[ "$selection" == "Sunrise and Sunset" ]]; then
	firefox "https://www.timeanddate.com/sun/@$(cat $HOME/Programs/output/updated/curLocation.csv | tr "|" ",")"
elif [[ "$selection" == "Weather MetOffice" ]]; then
	openMetOfficeCurLocation
elif [[ "$selection" == "Observations MetOffice" ]]; then
	openMetOfficeObservations
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
