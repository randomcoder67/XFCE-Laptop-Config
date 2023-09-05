#!/usr/bin/env bash

oldIFS="$IFS"
IFS=$'\n'

shows=( $(find ~/Videos/Media -maxdepth 1 -mindepth 1 | sort | grep -iv vampire) )

for show in "${shows[@]}"; do
	showName=$(basename "$show")
	seasons=( $(find "$show" -mindepth 1 -type d | sort) )
	for season in "${seasons[@]}"; do
		seasonName=$(basename "$season")
		seasonNumber=${seasonName/Season}
		episodes=( $(find "$season" -type f | sort) )
		for episode in "${episodes[@]}"; do
			episodeName=$(basename "$episode")
			episodeNumberA=${episodeName/Episode}
			episodeNumber=${episodeNumberA/.*}
			echo "Editing ${showName}, ${seasonName}, ${episodeName}"
			if echo "$episode" | grep -q '.webm'; then
				ffmpeg -i "$episode" -c copy -map_metadata 0 -metadata TITLE="$showName" -metadata SEASON_NUMBER="$seasonNumber" -metadata EPISODE_SORT="$episodeNumber" output.webm
				mv output.webm "$episode"
			else
				exiftool -overwrite_original -Title="$showName" -TVSeason="$seasonNumber" -TVEpisode="$episodeNumber" "$episode"
			fi
		done
	done
done
