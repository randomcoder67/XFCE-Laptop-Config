#!/usr/bin/env bash

# Script to check which streamers are live and where

saveLoc="$HOME/Programs/output/.streams/streamsCheck"

function checkYouTube() {
	# Set variables
	local channelName="$1"
	local youtubeChannelAt="$2"
	
	# Get space-padded name
	local printableChannelName="${channelName}:"
	spacesToAdd="$(($longestName-${#channelName}))"
	for i in $(seq 0 $((spacesToAdd))); do
		printableChannelName="${printableChannelName} "
	done
	
	# Check live status
	if ! curl -s "https://www.youtube.com/@${youtubeChannelAt}/live" > "${saveLoc}/${channelName}YouTube.html"; then
		echo "${printableChannelName} No Internet" > "${saveLoc}/results/${channelName}.txt"
		return 0
	# If no error, then there is an internet connection
	elif grep -q "Pop-out chat" "${saveLoc}/${channelName}YouTube.html"; then
		# Check if stream scheduled
		if grep -q "Live in" "${saveLoc}/${channelName}YouTube.html" || grep "Waiting for" "${saveLoc}/${channelName}YouTube.html" | grep -v -q "Internet connection"; then
			local liveAt=$(awk '/subtitleText/ { match($0, /subtitleText/); print substr($0, RSTART, RLENGTH + 60); }' "${saveLoc}/${channelName}YouTube.html" | cut -d "\"" -f 5)
			#local streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' ${saveLoc}/${channelName}YouTube.html | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "${printableChannelName} Scheduled (YouTube) at ${liveAt}" > "${saveLoc}/results/${channelName}.txt"
			return 0
		# Or waiting for streamer
		elif grep -q "Waiting for ${channelName}" "${saveLoc}/${channelName}YouTube.html"; then
			echo "${printableChannelName} Waiting for Streamer (YouTube)" > "${saveLoc}/results/${channelName}.txt"
		# Otherwise they are live now
		else
			#local streamTitle=$(awk '/videoDescriptionHeaderRenderer/ { match($0, /videoDescriptionHeaderRenderer/); print substr($0, RSTART, RLENGTH + 200); }' "${saveLoc}/${channelName}YouTube.html" | cut -d "\"" -f 9 | sed 's/&/and/g')
			echo "${printableChannelName} Live (YouTube)" > "${saveLoc}/results/${channelName}.txt"
			return 0
		fi
	else
		echo "${printableChannelName} Not Live" > "${saveLoc}/results/${channelName}.txt"
		return 1
	fi
}

function checkTwitch() {
	# Set variables
	local channelName="$1"
	local twitchAt="$2"
	
	# Get space-padded name
	local printableChannelName="${channelName}:"
	spacesToAdd="$(($longestName-${#channelName}))"
	for i in $(seq 0 $((spacesToAdd))); do
		printableChannelName="${printableChannelName} "
	done
	
	# Check live status
	if yt-dlp -q --write-info-json --skip-download "https://www.twitch.tv/${twitchAt}" -P ${saveLoc} -o "${channelName}TwitchMetadata.%(ext)s" 2>/dev/null > /dev/null; then
		#streamTitle=$(cat "${saveLoc}/${channelName}TwitchMetadata.info.json" | jq -r .description | sed 's/&/and/g')
		echo "${printableChannelName} Live (Twitch)" > "${saveLoc}/results/${channelName}.txt"
		return 0
	else
		echo "${printableChannelName} Not Live" > "${saveLoc}/results/${channelName}.txt"
		return 1
	fi
}

function checkAllPlatforms() {
	local channelName="$1"
	local youtubeChannelAt="$2"
	local twitchAt="$3"
	
	local liveYouTube="false"
	local liveTwitch="false"
	
	if [[ "$youtubeChannelAt" != "NONE" ]]; then
		checkYouTube "$channelName" "$youtubeChannelAt" && local liveYouTube="true"
	fi
	if [[ "$liveYouTube" == "false" ]] && [[ "$twitchAt" != "NONE" ]]; then
		checkTwitch "$channelName" "$twitchAt" && local liveTwitch="true"
	fi
}

# Define streamers, and their YouTube and Twitch @s
oldIFS="$IFS"
IFS=$'\n'
streamers=( $(cat "$HOME/Programs/output/updated/streamers.txt") )
IFS="$oldIFS"

# Count number of streamers
numStreamers=$((${#streamers[@]}/3))
longestName=0

# Find longest name
for i in $(seq 0 $((numStreamers-1))); do
	offset=$((i*3))
	
	currentName="${streamers[$offset]}"
	currentLength=${#currentName}
	
	if (( currentLength > longestName )); then
		longestName="$currentLength"
	fi
done

# Check all platforms for each streamer
for i in $(seq 0 $((numStreamers-1))); do
	offset=$((i*3))
	channelName="${streamers[$offset]}"
	youtubeChannelAt="${streamers[$((offset+1))]}"
	twitchAt="${streamers[$((offset+2))]}"
	
	checkAllPlatforms "$channelName" "$youtubeChannelAt" "$twitchAt" &
done

# Wait for background commands to finish
wait

# Print results
for i in $(seq 0 $((numStreamers-1))); do
	offset=$((i*3))
	cat "${saveLoc}/results/${streamers[$offset]}.txt"
done
