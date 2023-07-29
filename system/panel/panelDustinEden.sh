#!/usr/bin/env bash

# Panel NerdCubed stream monitor

curl https://www.twitch.tv/dustineden > ~/Programs/output/.streams/panel/dustineden.html
if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/dustineden.html
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title=\"Dustin Eden\" https://www.twitch.tv/dustineden</txtclick>"
		echo "<tool>Twitch</tool>"
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/dustineden.txt"
	else
		echo "<txt>  </txt>"
		echo "<tool>Not Live</tool>"
	fi
fi
