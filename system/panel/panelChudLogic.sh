#!/usr/bin/env bash

# Panel Chud Logic stream monitor

curl https://www.youtube.com/@ChudLogic/live > ~/Programs/output/.streams/panel/chudyoutube.html
curl https://www.twitch.tv/chudlogic > ~/Programs/output/.streams/panel/chudtwitch.html


if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudtwitch.html
then
	echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv --title='Chud Logic' https://www.twitch.tv/chudlogic</txtclick><tool>"
elif grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudyoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		echo "  "
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@ChudLogic/live</txtclick><tool>"
	fi
else
	echo "  "
fi
