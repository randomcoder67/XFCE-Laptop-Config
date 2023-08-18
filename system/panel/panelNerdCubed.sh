#!/usr/bin/env bash

# Panel NerdCubed stream monitor

#curl "https://www.twitch.tv/nerdcubed" > ~/Programs/output/.streams/panel/nerdcubedTwitch.html
#if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/nerdcubedTwitch.html
if yt-dlp -F "https://www.twitch.tv/nerdcubed"
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/nerdcubed.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --ytdl-format=best --title='NerdCubed - Twitch' https://www.twitch.tv/nerdcubed</txtclick>"
		curl "https://www.twitch.tv/nerdcubed" > ~/Programs/output/.streams/panel/nerdcubedTwitch.html
		streamTitle=$(awk '/og:description/ { match($0, /og:description/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/nerdcubedTwitch.html | cut -d "\"" -f 3)
		echo "<tool>Twitch - $streamTitle</tool>"
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/nerdcubed.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.twitch.tv/nerdcubed/videos?filter=archives&sort=time'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
