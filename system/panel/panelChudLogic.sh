#!/usr/bin/env bash

# Panel Chud Logic stream monitor

curl https://www.youtube.com/@ChudLogic/live > ~/Programs/output/.streams/panel/chudyoutube.html
curl https://www.twitch.tv/chudlogic > ~/Programs/output/.streams/panel/chudtwitch.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudyoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/chudyoutube.html
	then
		if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudtwitch.html
		then
			echo echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/terminal/alias/chud.sh</txtclick><tool>"
		else
			echo "  "
		fi
	else
		echo echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@ChudLogic/live</txtclick><tool>"
	fi
elif grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudtwitch.html
then
	echo echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/terminal/alias/chud.sh</txtclick><tool>"
else
	echo "  "
fi
