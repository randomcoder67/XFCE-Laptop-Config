#!/usr/bin/env bash

# Panel Chud Logic stream monitor

curl https://www.youtube.com/@ChudLogic/live > ~/Programs/output/.streams/panel/chudyoutube.html
curl https://www.twitch.tv/chudlogic > ~/Programs/output/.streams/panel/chudtwitch.html


if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudtwitch.html
then
	echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Chud Logic' https://www.twitch.tv/chudlogic</txtclick>"
	echo "<tool>Twitch</tool>"
elif grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudyoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		echo "<txt>  </txt>"
		echo "<tool>Stream Schedueled</tool>"
	elif grep -q "Waiting for Chud Logic" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		echo "<txt>  </txt>"
		echo "<tool>Waiting for Chud Logic</tool>" 
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@ChudLogic/live</txtclick>"
		echo "<tool>YouTube</tool>"
	fi
else
	echo "<txt>  </txt>"
	echo "<tool>Not Live</tool>"
fi
