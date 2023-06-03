#!/usr/bin/env bash

# Panel NerdCubed stream monitor

curl https://www.twitch.tv/nerdcubed > ~/Programs/output/.streams/panel/nerdcubed.html
if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/nerdcubed.html
then
	echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title=NerdCubed https://www.twitch.tv/nerdcubed</txtclick><tool>"
	echo "<tool>Twitch</tool>"
else
	echo "<txt>  </txt>"
	echo "<tool>Not Live</tool>"
fi
