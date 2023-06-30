#!/usr/bin/env bash

# Panel Chud Logic stream monitor

curl https://www.youtube.com/@ChudLogic/live > ~/Programs/output/.streams/panel/chudyoutube.html
curl https://www.twitch.tv/chudlogic > ~/Programs/output/.streams/panel/chudtwitch.html


if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudtwitch.html
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/chud.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Chud Logic' https://www.twitch.tv/chudlogic</txtclick>"
		echo "<tool>Twitch</tool>"
	fi
elif grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudyoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
		else
			echo "<txt>  </txt>"
			echo "<tool>Stream Schedueled</tool>"
		fi
	elif grep -q "Waiting for Chud Logic" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
		else
			echo "<txt>  </txt>"
			echo "<tool>Not Live</tool>"
		fi 
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/chud.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@ChudLogic/live</txtclick>"
			echo "<tool>YouTube</tool>"
		fi
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
	else
		echo "<txt>  </txt>"
		echo "<tool>Not Live</tool>"
	fi
fi
