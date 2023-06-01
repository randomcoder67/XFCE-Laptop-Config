#!/usr/bin/env bash

# Current wstream script, used to download Destiny stream from YouTube, Rumble or Kick

while true
do
	fileName=$(date +"d%y%m%dt%H%M%S")

	timeout 10 curl -s https://www.youtube.com/@Destiny/live > ~/Programs/output/.streams/destinyDownload/destinyyoutube.html
	timeout 10 curl -s https://rumble.com/c/Destiny > ~/Programs/output/.streams/destinyDownload/destinyrumble.html

	if grep -q "Pop-out chat" ~/Programs/output/.streams/destinyDownload/destinyyoutube.html
	then
		yt-dlp --external-downloader-args "'-m3u8_hold_counters' 10" https://www.youtube.com/@destiny/live -f 300 -P ~/Videos/Destiny/ -o $fileName"YouTube.%(ext)s"
	elif yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox -F https://kick.com/destiny 2>/dev/null >> /dev/null
	then
		yt-dlp --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0" --cookies-from-browser firefox https://kick.com/destiny -f 3 --external-downloader-args "'-m3u8_hold_counters' 10" -P ~/Videos/Destiny/ -o $fileName"Kick.%(ext)s"
	elif grep -q "class=video-item--live" ~/Programs/output/.streams/destinyDownload/destinyrumble.html
	then
		url=$(python3 ~/Programs/system/urlExtract.py)
		yt-dlp "$url" --external-downloader-args "'-m3u8_hold_counters' 10" -P ~/Videos/Destiny/ -o $fileName"Rumble.%(ext)s"
	else
		echo "Ain't no way"
	fi
	currentHour=$(date +"%-H")
	if (( $currentHour > 6 )) && (( $currentHour < 15 ))
	then
		sleep 300
	else
		sleep 10
	fi
done
