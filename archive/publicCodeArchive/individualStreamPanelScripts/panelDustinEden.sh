#!/usr/bin/env bash

# Panel Dustin Eden stream monitor

notLiveColour="e6e1dc"
liveColour="da4939"
upcomingColour="a5c261"
noInternetColour="ffc66d"

argA=$1

if [[ "$1" == "-d" ]]; then
	notLiveColour="fefef8"
	liveColour="e64747"
	upcomingColour="8CFF82"
	noInternetColour="fd7fbe"
	argA=$2
fi

if ! curl "https://www.twitch.tv/dustineden" > ~/Programs/output/.streams/panel/dustinedenTwitch.html; then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$noInternetColour'>  </span>"
		echo "noInternet" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
		echo "<tool>No Internet Connection</tool>"
	fi
#if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/dustinedenTwitch.html
elif yt-dlp --write-info-json --skip-download https://www.twitch.tv/dustineden -P ~/Programs/output/.streams/panel -o "dustinedenTwitchMetadata.%(ext)s"
then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$liveColour'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh dustinedenTwitch</txtclick>"
		streamTitle=$(cat ~/Programs/output/.streams/panel/dustinedenTwitchMetadata.info.json | jq -r .description | sed 's/&/and/g')
		echo "<tool>Twitch - $streamTitle</tool>"
	fi
else
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$notLiveColour'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.twitch.tv/dustineden/videos?filter=archives&sort=time'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
