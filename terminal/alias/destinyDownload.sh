#!/usr/bin/env bash

# Current wstream script, used to download Destiny stream from YouTube, Rumble or Kick (painstiny)

while true
do
	fileName=$(date +"d%y%m%dt%H%M%S") # File name is set to current date + time in oorder to make sure no files are overwritten

	# Download YouTube and Rumble pages to check for livestream
	timeout 10 curl -s "https://www.youtube.com/@Destiny/live" > ~/Programs/output/.streams/destinyDownload/destinyYouTube.html
	timeout 10 curl -s "https://rumble.com/c/Destiny" > ~/Programs/output/.streams/destinyDownload/destinyRumble.html

	# Check YouTube for livestream 
	if grep -q "Pop-out chat" ~/Programs/output/.streams/destinyDownload/destinyYouTube.html
	then
		yt-dlp https://www.youtube.com/@destiny/live -f 300 -P ~/Videos/Destiny/ -o $fileName"YouTube.%(ext)s"
	# Check Kick for livestream (this part only sometimes works)
	elif yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox -F https://kick.com/destiny 2>/dev/null >> /dev/null
	then
		yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox https://kick.com/destiny -f 3 --external-downloader-args "'-m3u8_hold_counters' 10" -P ~/Videos/Destiny/ -o $fileName"Kick.%(ext)s"
	# Check Rumble for livestream 
	elif grep -q "class=video-item--live" ~/Programs/output/.streams/destinyDownload/destinyRumble.html
	then
		url=$(python3 ~/Programs/system/urlExtract.py)
		yt-dlp "$url" --external-downloader-args "'-m3u8_hold_counters' 10" -P ~/Videos/Destiny/ -o $fileName"Rumble.%(ext)s"
	else
		echo "Ain't no way"
	fi
	currentHour=$(TZ=America/New_York date +"%-H")
	if (( $currentHour > 2 )) && (( $currentHour < 12 )) # If the time is between 0300 and 1100 Miami time, then sleep for longer as it's very unlikely the stream is live 
	then
		sleep 300
	else
		sleep 10
	fi
done
