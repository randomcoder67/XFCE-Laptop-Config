#!/usr/bin/env bash

# Panel Noah Sunday stream monitor

curl "https://www.youtube.com/@NoahSundayCompletionist/live" > ~/Programs/output/.streams/panel/noahsundayYouTube.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/noahsundayYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/noahsundayYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/noahsunday.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/noahsundayYouTube.html | cut -d "\"" -f 5)
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/noahsundayYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>Stream Schedueled at $liveAt - $streamTitle</tool>"
		fi
	elif grep -q "Waiting for Noah Sunday" ~/Programs/output/.streams/panel/noahsundayYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/noahsunday.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			echo "<tool>Waiting for Noah Sunday</tool>"
		fi 
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/noahsunday.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh noahsundayYouTube</txtclick>"
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/noahsundayYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>YouTube - $streamTitle</tool>"
		fi
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#e6e1dc'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/noahsunday.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/@NoahSundayCompletionist/streams'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
