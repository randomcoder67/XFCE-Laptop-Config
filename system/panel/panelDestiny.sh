#!/usr/bin/env bash

# Panel Destiny stream monitor

curl https://www.youtube.com/@Destiny/live > ~/Programs/output/.streams/panel/destinyYouTube.html
curl -s https://rumble.com/c/Destiny > ~/Programs/output/.streams/panel/destinyRumble.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/destinyYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt>  </txt>"
			echo "<tool>Not Live</tool>"
		fi
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "youtube" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@Destiny/live</txtclick>"
			echo "<tool>YouTube</tool>"
		fi
	fi
elif grep -q "class=video-item--live" ~/Programs/output/.streams/panel/destinyRumble.html
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "rumble" > "$XDG_STATE_HOME/streams/destiny.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/destinyRumble.sh</txtclick>"
		echo "<tool>Rumble</tool>"
	fi
else
	#python3 loadKick.py 2>/dev/null >> /dev/null
	if yt-dlp -F https://kick.com/destiny 2>/dev/null >> /dev/null
	then
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#da4939'>  </span>"
			echo "kick" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt><span foreground='#da4939'>  <span></txt><txtclick>mpv https://kick.com/destiny</txtclick>"
			echo "<tool>Kick</tool>"
		fi
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/destiny.txt"
		else
			echo "<txt>  </txt>"
			echo "<tool>Not Live</tool>"
		fi
	fi
fi
