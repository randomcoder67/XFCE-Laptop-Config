#!/usr/bin/env bash

# Panel Chud Logic stream monitor

#curl "https://www.twitch.tv/chudlogic" > ~/Programs/output/.streams/panel/chudlogicTwitch.html
#if grep -q "isLiveBroadcast" ~/Programs/output/.streams/panel/chudlogicTwitch.html
if yt-dlp --write-info-json --skip-download https://www.twitch.tv/chudlogic -P ~/Programs/output/.streams/panel -o "chudlogicTwitchMetadata.%(ext)s"
then
	if [[ "$1" == "-t" ]]; then
		echo "<span foreground='#da4939'>  </span>"
		echo "twitch" > "$XDG_STATE_HOME/streams/chud.txt"
	else
		echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh chudlogicTwitch</txtclick>"
		streamTitle=$(cat ~/Programs/output/.streams/panel/chudlogicTwitchMetadata.info.json | jq -r .description | sed 's/&/and/g')
		echo "<tool>Twitch - $streamTitle</tool>"
	fi
else
	curl "https://www.youtube.com/@ChudLogic/live" > ~/Programs/output/.streams/panel/chudlogicYouTube.html
	if grep -q "Pop-out chat" ~/Programs/output/.streams/panel/chudlogicYouTube.html
	then
		if grep -q "Live in" ~/Programs/output/.streams/panel/chudlogicYouTube.html
		then
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#a5c261'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#a5c261'>  </span></txt>"
				liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' ~/Programs/output/.streams/panel/chudlogicYouTube.html | cut -d "\"" -f 5)
				streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/chudlogicYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
				echo "<tool>Stream Schedueled at $liveAt - $streamTitle</tool>"
			fi
		elif grep -q "Waiting for Chud Logic" ~/Programs/output/.streams/panel/chudlogicYouTube.html
		then
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#a5c261'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#a5c261'>  </span></txt>"
				echo "<tool>Waiting for Chud Logic</tool>"
			fi 
		else
			if [[ "$1" == "-t" ]]; then
				echo "<span foreground='#da4939'>  </span>"
				echo "youtube" > "$XDG_STATE_HOME/streams/chud.txt"
			else
				echo "<txt><span foreground='#da4939'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh chudlogicYouTube</txtclick>"
				streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ~/Programs/output/.streams/panel/chudlogicYouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
				echo "<tool>YouTube - $streamTitle</tool>"
			fi
		fi
	else
		if [[ "$1" == "-t" ]]; then
			echo "<span foreground='#e6e1dc'>  </span>"
			echo "notLive" > "$XDG_STATE_HOME/streams/chud.txt"
		else
			echo "<txt>  </txt><txtclick>firefox --new-tab 'https://www.twitch.tv/chudlogic/videos?filter=archives&sort=time' --new-tab 'https://www.youtube.com/playlist?list=PLzkM5r4tBX8vRVgA4hLQAHlTFAE7EPO05'</txtclick>"
			echo "<tool>Not Live</tool>"
		fi
	fi
fi
