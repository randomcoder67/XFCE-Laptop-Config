#!/usr/bin/env bash

# Panel MATN stream monitor

curl https://www.youtube.com/@ManyATrueNerd/live > ~/Programs/output/.streams/panel/matn.html
if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/matn.html
then
	if grep -q "Live in" ~/Programs/output/.streams/panel/matn.html
	then
		echo "  "
	else
		echo  "<txt><span foreground='#da4939'>  </span></txt><txtclick>mpv https://www.youtube.com/@ManyATrueNerd/live</txtclick><tool>"
	fi
else
	echo "  "
fi