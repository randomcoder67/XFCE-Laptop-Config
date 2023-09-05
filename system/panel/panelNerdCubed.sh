#!/usr/bin/env bash

# Panel NerdCubed stream monitor

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

if ! curl "https://www.twitch.tv/nerdcubed" > ~/Programs/output/.streams/panel/nerdcubedTwitch.html; then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$noInternetColour'>  </span>"
		echo "noInternet" > "$XDG_STATE_HOME/streams/nerdcubed.txt"
	else
		echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
		echo "<tool>No Internet Connection</tool>"
	fi
#if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/nerdcubedTwitch.html
elif yt-dlp -F "https://www.twitch.tv/nerdcubed"
then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$liveColour'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/nerdcubed.txt"
	else
		echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh nerdcubedTwitch</txtclick>"
		curl "https://www.twitch.tv/nerdcubed" > ~/Programs/output/.streams/panel/nerdcubedTwitch.html
		streamTitle=$(awk '/og:description/ { match($0, /og:description/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/nerdcubedTwitch.html | cut -d "\"" -f 3)
		echo "<tool>Twitch - $streamTitle</tool>"
	fi
else
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$notLiveColour'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/nerdcubed.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.twitch.tv/nerdcubed/videos?filter=archives&sort=time'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
