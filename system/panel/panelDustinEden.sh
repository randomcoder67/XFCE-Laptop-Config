#!/usr/bin/env bash

# Panel Dustin Eden stream monitor

#curl "https://www.twitch.tv/dustineden" > ~/Programs/output/.streams/panel/dustinedenTwitch.html
#if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/dustinedenTwitch.html
if yt-dlp -F "https://www.twitch.tv/dustineden"
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --ytdl-format=best --title=\"Dustin Eden - Twitch\" https://www.twitch.tv/dustineden</txtclick>"
		curl "https://www.twitch.tv/dustineden" > ~/Programs/output/.streams/panel/dustinedenTwitch.html
		streamTitle=$(awk '/og:description/ { match($0, /og:description/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/dustinedenTwitch.html | cut -d "\"" -f 3 | tr -d "#" | tr -d "!" | sed 's/&/and/g')
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
