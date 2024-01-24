#!/usr/bin/env bash

# Script to get my YouTube History and save it all to a file (per week)

tempDirName="$HOME/Programs/output/.temp"
dirName="$HOME/Programs/output/youtubeHistory"
yearWeek=$(date +"%y%m")
fileName="${yearWeek}.csv"

output=$(yt-dlp --cookies-from-browser firefox --flat-playlist -J --playlist-end 2000 "https://www.youtube.com/feed/history")

echo "$output" | jq '.entries[] | [.title,.channel,.url] | @csv' > "${dirName}/${fileName}" 

cat -n "${dirName}/${fileName}" | sort -uk2 | sort -n | cut -f2- > "${tempDirName}/youtubeHistoryTemp.csv"
mv "${tempDirName}/youtubeHistoryTemp.csv" "${dirName}/${fileName}"
