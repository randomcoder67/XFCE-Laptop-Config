#!/usr/bin/env bash

# Script to check which streamers are live and where

# Get webpages, runs all commands in parralel and waits for them all to finish, twice as fast as having them in series
timeout 10 curl -s https://www.youtube.com/@Destiny/live > ~/Programs/output/.streams/streamsCheck/destinyyoutube.html &
timeout 10 curl -s https://rumble.com/c/Destiny > ~/Programs/output/.streams/streamsCheck/destinyrumble.html &
timeout 10 curl -s https://www.youtube.com/@ChudLogic/live > ~/Programs/output/.streams/streamsCheck/chudyoutube.html &
timeout 10 curl -s https://www.twitch.tv/chudlogic > ~/Programs/output/.streams/streamsCheck/chudtwitch.html &
timeout 10 curl -s https://www.twitch.tv/nerdcubed > ~/Programs/output/.streams/streamsCheck/nerdcubed.html &
timeout 10 curl -s https://www.youtube.com/@ManyATrueNerd/live > ~/Programs/output/.streams/streamsCheck/matn.html &
timeout 10 curl -s https://www.twitch.tv/dustineden > ~/Programs/output/.streams/streamsCheck/dustineden.html &
wait

# Destiny check 
if grep -q "Pop-out chat" ~/Programs/output/.streams/streamsCheck/destinyyoutube.html
then
	echo "Destiny:	 Live (YouTube)"
elif yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox -F https://kick.com/destiny 2>/dev/null >> /dev/null
then
	echo "Destiny:	 Live (Kick)"
elif grep -q "class=video-item--live" ~/Programs/output/.streams/streamsCheck/destinyrumble.html
then
	echo "Destiny:	 Live (Rumble)"
else
	echo "Destiny:	 Not Live"
fi

# Chud Logic Check 
if grep -q "Pop-out chat" ~/Programs/output/.streams/streamsCheck/chudyoutube.html
then
	if grep -q "Live in" ~/Programs/output/.streams/streamsCheck/chudyoutube.html; then
		liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/chudyoutube.html | cut -d "\"" -f 5)
		echo "Chud Logic:  Scheduled (YouTube) at $liveAt"
	elif grep -q "Waiting for Chud Logic" ~/Programs/output/.streams/streamsCheck/chudyoutube.html; then
		echo "Chud Logic:  Waiting (YouTube)"
	else
		echo "Chud Logic:  Live (YouTube)"
	fi
elif grep -q "isLiveBroadcast" ~/Programs/output/.streams/streamsCheck/chudtwitch.html
then
	echo "Chud Logic:  Live (Twitch)"
else
	echo "Chud Logic:  Not Live"
fi

# NerdCubed check 
if grep -q isLiveBroadcast ~/Programs/output/.streams/streamsCheck/nerdcubed.html
then
	echo "NerdCubed:   Live (Twitch)"
else
	echo "NerdCubed:   Not Live"
fi

# MATN Check
if grep -q "Pop-out chat" ~/Programs/output/.streams/streamsCheck/matn.html
then
	echo "MATN:		Live (YouTube)"
else
	echo "MATN:		Not Live"
fi

# Dustin Eden Check
if grep -q "Pop-out chat" ~/Programs/output/.streams/streamsCheck/dustineden.html
then
	echo "Dustin Eden: Live (Twitch)"
else
	echo "Dustin Eden: Not Live"
fi
