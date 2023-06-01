#!/usr/bin/env bash

# Script to play Destiny stream on currently live platform

timeout 10 curl -s https://www.youtube.com/@Destiny/live > ~/Programs/output/.streams/streamsCheck/destinyyoutube.html

if grep -q "Pop-out chat" ~/Programs/output/.streams/streamsCheck/destinyyoutube.html
then
	echo "Live on YouTube"
	mpv https://www.youtube.com/@Destiny/live & disown
else
	echo "Not live on YouTube"
	if yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox -F https://kick.com/destiny 2>/dev/null >> /dev/null
	then
		echo "Live on Kick"
		mpv https://www.kick.com/destiny
	else
		echo "Not live on Kick"
		timeout 10 curl -s https://rumble.com/c/Destiny > ~/Programs/output/.streams/streamsCheck/destinyrumble.html
		if grep -q "class=video-item--live" ~/Programs/output/.streams/streamsCheck/destinyrumble.html
		then
			~Programs/system/panel/destinyRumble.sh
		else
			echo "Not live on Rumble"
		fi
	fi
fi
