#!/usr/bin/env bash

# Panel Stream Monitor
# Usage: ./streamChecker.sh channel_name youtube_channel_@ twitch_@ theme_flag

# Constants

saveLoc="$HOME/Programs/output/.streams/panel"
channelName="$1"
youtubeChannelAt="$2"
twitchAt="$3"

# Set colours

notLiveColour="e6e1dc"
liveColour="da4939"
upcomingColour="a5c261"
noInternetColour="ffc66d"

if [[ "$4" == "-d" ]]; then
	notLiveColour="fefef8"
	liveColour="e64747"
	upcomingColour="8CFF82"
	noInternetColour="fd7fbe"
fi

liveYouTube="false"
liveTwitch="false"

if [[ "$youtubeChannelAt" != "NONE" ]]; then
	# Download and check for internet
	if ! curl "https://www.youtube.com/@${youtubeChannelAt}/live" > "${saveLoc}/${channelName}YouTube.html"; then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$noInternetColour'>  </span>"
			echo "noInternet" > "$XDG_STATE_HOME/streams/${channelName}.txt"
		else
			echo "<txt><span foreground='#$noInternetColour'>  </span></txt>"
			echo "<tool>No Internet Connection</tool>"
		fi
	
	# Check for live status
	elif grep -q "Pop-out chat" "${saveLoc}/${channelName}YouTube.html"; then
		# Check if stream scheduled
		if grep -q "Live in" "${saveLoc}/${channelName}YouTube.html"
		then
			if [[ "$argA" == "-t" ]]; then
				echo "<span foreground='#$upcomingColour'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/${channelName}.txt"
			else
				echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
				liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' "${saveLoc}/${channelName}YouTube.html" | cut -d "\"" -f 5)
				streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' "${saveLoc}/${channelName}YouTube.html" | cut -d "\"" -f 9 | sed 's/&/and/g' | sed 's/\\u0026/and/g')
				echo "<tool>Stream Schedueled at $liveAt - $streamTitle</tool>"
			fi
			liveYouTube="true"
		# Or waiting for streamer
		elif grep -q "Waiting for ${channelName}" "${saveLoc}/${channelName}YouTube.html"; then
			if [[ "$argA" == "-t" ]]; then
				echo "<span foreground='#$upcomingColour'>  </span>"
				echo "notLive" > "$XDG_STATE_HOME/streams/${channelName}.txt"
			else
				echo "<txt><span foreground='#$upcomingColour'>  </span></txt>"
				echo "<tool>Waiting for ${channelName}</tool>"
			fi
			liveYouTube="true"
		# Otherwise they are live now
		else
			if [[ "$argA" == "-t" ]]; then
				echo "<span foreground='#$liveColour'>  </span>"
				echo "youtube" > "$XDG_STATE_HOME/streams/${channelName}.txt"
			else
				echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh YouTube \"${channelName}\" \"${youtubeChannelAt}\"</txtclick>"
				streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' "${saveLoc}/${channelName}YouTube.html" | cut -d "\"" -f 9 | sed 's/&/and/g' | sed 's/\\u0026/and/g')
				echo "<tool>YouTube - $streamTitle</tool>"
			fi
			liveYouTube="true"
		fi
	fi
fi

if [[ "$twitchAt" != "NONE" ]] && [[ "$liveYouTube" == "false" ]]; then
	if yt-dlp --write-info-json --skip-download "https://www.twitch.tv/${twitchAt}" -P ${saveLoc} -o "${channelName}TwitchMetadata.%(ext)s"; then
		if [[ "$argA" == "-t" ]]; then
			echo "<span foreground='#$liveColour'>  </span>"
			echo "twitch" > "$XDG_STATE_HOME/streams/${channelName}.txt"
		else
			echo "<txt><span foreground='#$liveColour'>  </span></txt><txtclick>$HOME/Programs/system/panel/streamLauncher.sh Twitch \"${channelName}\" \"${twitchAt}\"</txtclick>"
			streamTitle=$(cat "${saveLoc}/${channelName}TwitchMetadata.info.json" | jq -r .description | sed 's/&/and/g')
			echo "<tool>Twitch - $streamTitle</tool>"
		fi
		liveTwitch="true"
	fi
fi

if [[ "$liveYouTube" == "false" ]] && [[ "$liveTwitch" == "false" ]]; then
	if [[ "$5" == "-t" ]]; then
		echo "<span foreground='#$notLiveColour'>  </span>"
		echo "notLive" > "$XDG_STATE_HOME/streams/${channelName}.txt"
	else
		urlOpenString="firefox"
		if [[ "$youtubeChannelAt" != "NONE" ]]; then
			urlOpenString="${urlOpenString} --new-tab 'https://www.youtube.com/@${youtubeChannelAt}'"
		fi
		if [[ "$twitchAt" != "NONE" ]]; then
			urlOpenString="${urlOpenString} --new-tab 'https://www.twitch.tv/${twitchAt}/videos?filter=archives&sort=time'"
		fi
		echo "<txt>  </txt><txtclick>${urlOpenString}</txtclick>"
		echo "<tool>Not Live</tool>"
	fi
fi
