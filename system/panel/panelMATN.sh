#!/usr/bin/env bash

# Panel MATN stream monitor

curl "https://www.youtube.com/@ManyATrueNerd/live" > ~/Programs/output/.streams/panel/matnYoutube.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/matnYoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/matnYoutube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/matnYoutube.html | cut -d "\"" -f 5)
			echo "<tool>Stream Schedueled at $liveAt</tool>"
		fi
	elif grep -q "Waiting for MATN" ~/Programs/output/.streams/panel/matnYoutube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			echo "<tool>Waiting for MATN</tool>"
		fi 
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --ytdl-format=best --title='MATN - YouTube' https://www.youtube.com/@ManyATrueNerd/live</txtclick>"
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/matnYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>YouTube - $streamTitle</tool>"
		fi
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/@ManyATrueNerd/streams'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
