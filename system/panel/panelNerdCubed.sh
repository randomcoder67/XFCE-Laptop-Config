#!/usr/bin/env bash

# Panel NerdCubed stream monitor

curl https://www.twitch.tv/nerdcubed > ~/Programs/output/.streams/panel/nerdcubed.html
if grep -q isLiveBroadcast ~/Programs/output/.streams/panel/nerdcubed.html
then
	echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/terminal/alias/nerdcubed.sh</txtclick><tool>"
else
	echo "  "
fi
