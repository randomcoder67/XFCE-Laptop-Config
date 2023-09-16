#!/usr/bin/env bash

# Script to perform YouTube search and open desired result in mpv

# Get search term from input, doen't need quotes
searchTerm=$(echo "$@" | sed 's/ /+/g')

# Get search results HTML, and find JSON within
result=$(curl -s "https://www.youtube.com/results?search_query=$searchTerm" | grep "ytInitialData" | \
sed -n 's/.*ytInitialData = \(.*\)/\1/p' | cut -d ";" -f 1) 

# Find the array of resuls
mainResults=$(echo "$result" | jq .contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents[0].itemSectionRenderer.contents)

# Get the length of the array
len=$(echo "$mainResults" | jq '. | length')

# Create array to hold videoIDs
arrayOfVideos=()
# Create index to display
index=1
# Loop through videos in mainResults
for ((i=0; i<len; i++)); do
	# videoRenderer will be the top level key if it's a proper search result, not "other people also viewed"
	if $(echo "$mainResults" | jq .[$i] | jq 'has("videoRenderer")'); then
		# Get specific video JSON
		video=$(echo "$mainResults" | jq .[$i])
		# Read relevant data into variables
		oldIFS="$IFS"
		IFS=$';'
		read -r videoID videoTitle videoChannel videoPublishedTime videoLength videoViews <<<$(echo "$video" | jq -r '[.videoRenderer.videoId,.videoRenderer.title.runs[0].text,.videoRenderer.longBylineText.runs[0].text,.videoRenderer.publishedTimeText.simpleText,.videoRenderer.lengthText.simpleText,.videoRenderer.viewCountText.simpleText] | join (";")')
		# Restore IFS
		IFS="$oldIFS"
		# Add videoID to arrayOfVideos
		arrayOfVideos+=("$videoID")
		# Print listing in format "index: title - channel - release date - length - views"
		echo "$index: $videoTitle - $videoChannel - $videoPublishedTime - $videoLength - $videoViews"
		# Add one to index
		indexA=$((index+1))
		index="$indexA"
	fi
done

# Get user selection, exit if q, blank or out of range
read -p "Enter video to watch (q to quit): " videoSelection
[[ "$videoSelection" == "q" ]] || [[ "$videoSelection" == "" ]] || ((videoSelection>index-1)) && exit

# Open video
mpv --ytdl-format="best" "https://www.youtube.com/watch?v=${arrayOfVideos[$((videoSelection-1))]}" --really-quiet & disown

#echo $videoSelection
#echo "${arrayOfVideos[$((videoSelection-1))]}"
#sed -n 's/.*ytInitialData = \(.*\);.*/\1/p')
#actualResults=$(echo $result | jq .contents.twoColumnSearchResultsRenderer.primaryContents.\
#sectionListRenderer.contents[0].itemSectionRenderer.contents[1].shelfRenderer.content.verticalListRenderer.items)
#echo $actualResults | jq '.[0].videoRenderer.title.runs[0].text'
#echo $actualResults | jq '.[0]'
