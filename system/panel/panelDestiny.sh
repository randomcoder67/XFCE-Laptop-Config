#!/usr/bin/env bash

# Panel Destiny stream monitor

curl https://www.youtube.com/@Destiny/live > ~/Programs/output/.streams/panel/destinyYouTube.html
curl -s https://rumble.com/c/Destiny > ~/Programs/output/.streams/panel/destinyRumble.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/destinyYouTube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/destinyYouTube.html
	then
		echo "<txt>  </txt>"
		echo "<tool>Not Live</tool>"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@Destiny/live</txtclick><tool>"
		echo "<tool>YouTube</tool>"
	fi
elif grep -q "class=video-item--live" ~/Programs/output/.streams/panel/destinyRumble.html
then
	echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/destinyRumble.sh</txtclick><tool>"
	echo "<tool>Rumble</tool>"
else
	python3 loadKick.py 2>/dev/null >> /dev/null
	if yt-dlp -F https://kick.com/destiny 2>/dev/null >> /dev/null
	then
		echo "<txt><span foreground='#da4939'>  <span></txt><txtclick>mpv https://kick.com/destiny</txtclick><tool>"
		echo "<tool>Kick</tool>"
	else
		echo "<txt>  </txt>"
		echo "<tool>Not Live</tool>"
	fi
fi
