#!/usr/bin/env bash

# Panel Destiny stream monitor

curl "https://www.youtube.com/@Destiny/live" > ~/Programs/output/.streams/panel/destinyYouTube.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/destinyYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/destinyYouTube.html | cut -d "\"" -f 5)
			echo "$liveAt"
			echo "<tool>Stream Schedueled at $liveAt</tool>"
		fi
	elif grep -q "Waiting for Destiny" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#a5c261'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#a5c261'>  </span></txt>"
			echo "<tool>Waiting for Destiny</tool>"
		fi 
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Destiny - YouTube' https://www.youtube.com/@Destiny/live</txtclick>"
			echo "<tool>YouTube</tool>"
		fi
	fi
else
	curl -s "https://rumble.com/c/Destiny" > ~/Programs/output/.streams/panel/destinyRumble.html
	if grep -q "class=video-item--live" ~/Programs/output/.streams/panel/destinyRumble.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "rumble" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/destinyRumble.sh</txtclick>"
			echo "<tool>Rumble</tool>"
		fi
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.youtube.com/playlist?list=PLFs19LVskfNzQLZkGG_zf6yfYTp_3v_e6' 'https://kick.com/destiny'</txtclick>"
			echo "<tool>Not Live</tool>"
		fi
	fi
fi
