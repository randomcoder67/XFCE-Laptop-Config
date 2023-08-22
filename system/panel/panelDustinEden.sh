#!/usr/bin/env bash

# Panel Dustin Eden stream monitor

#curl "https://www.twitch.tv/dustineden" > ~/Programs/output/.streams/panel/dustinedenTwitch.html
#if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/dustinedenTwitch.html
if yt-dlp --write-info-json --skip-download https://www.twitch.tv/dustineden -P ~/Programs/output/.streams/panel -o "dustinedenTwitchMetadata.%(ext)s"
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh dustinedenTwitch</txtclick>"
		streamTitle=$(cat ~/Programs/output/.streams/panel/dustinedenTwitchMetadata.info.json | jq -r .description | sed 's/&/and/g')
		echo "<tool>Twitch - $streamTitle</tool>"
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.twitch.tv/dustineden/videos?filter=archives&sort=time'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
