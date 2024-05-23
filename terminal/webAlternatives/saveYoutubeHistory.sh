#!/usr/bin/env bash

# Script to get my YouTube History and save it all to a file (per week)

tempDirName="$HOME/Programs/output/.temp"
dirName="$HOME/Programs/output/youtubeHistory"
yearWeek=$(date +"%y%m")
fileName="${yearWeek}.csv"

if [[ "$1" == "-s" ]]; then
	grep -ir "$2" "$dirName"
	exit
fi

latestFile=$(ls "$dirName" | sort | tail -n 1)
lastRanString=$(stat "${dirName}/${latestFile}" | grep "Change" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}")
lastRan=$(date -d "$lastRanString" +"%s")
currentTime=$(date +"%s")

difference=$((currentTime-lastRan))
numEntriesToGetB=$((difference/864))
numEntriesToGetA=$((numEntriesToGetB*10))
numEntriesToGet=$((numEntriesToGetA+10))
echo "Saving $numEntriesToGet most recent entries to YouTube history"

output=$(yt-dlp --cookies-from-browser firefox --flat-playlist -J --playlist-end "$numEntriesToGet" "https://www.youtube.com/feed/history")
[[ "$?" == "1" ]] && exit

echo "$output" | jq '.entries[] | [.title,.channel,.url] | @csv' | tac >> "${dirName}/${fileName}" 

cat -n "${dirName}/${fileName}" | sort -uk2 | sort -n | cut -f2- > "${tempDirName}/youtubeHistoryTemp.csv"
mv "${tempDirName}/youtubeHistoryTemp.csv" "${dirName}/${fileName}"

# Ensure all videos in certain playlist downloaded
~/Programs/output/otherScripts/syncVideos.sh
