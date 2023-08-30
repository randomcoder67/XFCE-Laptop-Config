#!/usr/bin/env bash

# Panel MATN stream monitor

notLiveColour="e6e1dc"
liveColour="da4939"
upcomingColour="a5c261"

if [[ "$1" == "-d" ]]; then
	notLiveColour="fefef8"
	liveColour="e64747"
	upcomingColour="8CFF82"
fi

curl "https://www.youtube.com/@ManyATrueNerd/live" > ~/Programs/output/.streams/panel/matnYouTube.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/matnYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/matnYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/matnYouTube.html | cut -d "\"" -f 5)
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/matnYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>Stream Schedueled at $liveAt - $streamTitle</tool>"
		fi
	elif grep -q "Waiting for MATN" ~/Programs/output/.streams/panel/matnYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			echo "<tool>Waiting for MATN</tool>"
		fi 
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#$liveColour'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/matn.txt"
		else
			echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh matnYouTube</txtclick>"
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/matnYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>YouTube - $streamTitle</tool>"
		fi
	fi
else
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#$notLiveColour'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/matn.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/@ManyATrueNerd/streams'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
