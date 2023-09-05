#!/usr/bin/env bash

# Panel Destiny stream monitor

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

if ! curl -s "https://www.youtube.com/@Destiny/live" > ~/Programs/output/.streams/panel/destinyYouTube.html; then
	if [[ "$argA" == "-t" ]]; then
		echo "<span foreground='#$noInternetColour'>  </span>"
		echo "noInternet" > "$XDG_STATE_HOME/streams/destiny.txt"
	else
		echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
		echo "<tool>No Internet Connection</tool>"
	fi
elif grep -q "Pop-out chat" ~/Programs/output/.streams/panel/destinyYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/destinyYouTube.html | cut -d "\"" -f 5)
			echo "<tool>Stream Schedueled at $liveAt</tool>"
		fi
	elif grep -q "Waiting for Destiny" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$upcomingColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
			echo "<tool>Waiting for Destiny</tool>"
		fi 
	else
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$liveColour'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh destinyYouTube</txtclick>"
			streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/destinyYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "<tool>YouTube - $streamTitle</tool>"
		fi
	fi
else
	curl -s "https://rumble.com/c/Destiny" > ~/Programs/output/.streams/panel/destinyRumble.html
	if grep -q "class=video-item--live" ~/Programs/output/.streams/panel/destinyRumble.html
	then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$liveColour'>  </span>"
			echo "rumble" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh destinyRumble</txtclick>"
			echo "<tool>Rumble</tool>"
		fi
	else
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$notLiveColour'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/playlist?list=PLFs19LVskfNzQLZkGG_zf6yfYTp_3v_e6' --new-tab 'https://kick.com/destiny'</txtclick>"
			echo "<tool>Not Live</tool>"
		fi
	fi
fi
