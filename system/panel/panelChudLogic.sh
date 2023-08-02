#!/usr/bin/env bash

# Panel Chud Logic stream monitor

curl "https://www.twitch.tv/chudlogic" > ~/Programs/output/.streams/panel/chudlogicTwitch.html
if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudlogicTwitch.html
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/chud.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Chud Logic - Twitch' https://www.twitch.tv/chudlogic</txtclick>"
		echo "<tool>Twitch</tool>"
	fi
else
	curl "https://www.youtube.com/@ChudLogic/live" > ~/Programs/output/.streams/panel/chudlogicYouTube.html
	if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudlogicYouTube.html
	then
		if grep -q "Live in" ~/Programs/output/.streams/panel/chudlogicYouTube.html
		then
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#a5c261'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#a5c261'>  </span></txt>"
				liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/chudyoutube.html | cut -d "\"" -f 5)
				echo "$liveAt"
				echo "<tool>Stream Schedueled at $liveAt</tool>"
			fi
		elif grep -q "Waiting for Chud Logic" ~/Programs/output/.streams/panel/chudlogicYouTube.html
		then
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#a5c261'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#a5c261'>  </span></txt>"
				echo "<tool>Waiting for Chud Logic</tool>"
			fi 
		else
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#da4939'>  </span>"
				echo "youtube" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Chud Logic - YouTube' https://www.youtube.com/@ChudLogic/live</txtclick>"
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
fi
