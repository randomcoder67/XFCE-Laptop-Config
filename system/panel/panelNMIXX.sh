#!/usr/bin/env bash

# Panel NMIXX stream monitor

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

if ! curl "https://www.youtube.com/@NMIXXOfficial/live" > ~/Programs/output/.streams/panel/nmixxYouTube.html; then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$noInternetColour'>  </span>"
		echo "noInternet" > "$XDG_STATE_HOME/streams/nmixx.txt"
	else
		echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
		echo "<tool>No Internet Connection</tool>"
	fi
elif grep -q "Pop-out chat" ~/Programs/output/.streams/panel/nmixxYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/nmixxYouTube.html
	then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/nmixx.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/nmixxYouTube.html | cut -d "\"" -f 5)
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/nmixxYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>Stream Schedueled at $liveAt - $streamTitle</tool>"
		fi
	elif grep -q "Waiting for NMIXX" ~/Programs/output/.streams/panel/nmixxYouTube.html
	then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/nmixx.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			echo "<tool>Waiting for NMIXX</tool>"
		fi 
	else
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$liveColour'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/nmixx.txt"
		else
			echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh nmixxYouTube</txtclick>"
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/nmixxYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>YouTube - $streamTitle</tool>"
		fi
	fi
else
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$notLiveColour'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/nmixx.txt"
	else
		echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/@NMIXXOfficial/streams'</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
