#!/usr/bin/env bash

# Program to open livestreams in mpv and give appropriate error messages if they fail to open

if [[ "$1" == "matnYouTube" ]]; then
	notify-send "Opening Many A True Nerd YouTube Stream"
	mpv --ytdl-format=best --title='Many A True Nerd - YouTube' https://www.youtube.com/@ManyATrueNerd/live || notify-send "Error, stream failed to open"
elif [[ "$1" == "nmixxYouTube" ]]; then
	notify-send "Opening NMIXX YouTube Stream"
	mpv --ytdl-format=best --title='NMIXX - YouTube' https://www.youtube.com/@NMIXX/live || notify-send "Error, stream failed to open"
elif [[ "$1" == "chudlogicYouTube" ]]; then
	notify-send "Opening Chud Logic YouTube Stream"
	mpv --ytdl-format=best --title='Chud Logic - YouTube' https://www.youtube.com/@ChudLogic/live || notify-send "Error, stream failed to open"
elif [[ "$1" == "destinyYouTube" ]]; then
	notify-send "Opening Destiny YouTube Stream"
	mpv --ytdl-format=best --title='Destiny - YouTube' https://www.youtube.com/@Destiny/live || notify-send "Error, stream failed to open"
elif [[ "$1" == "chudlogicTwitch" ]]; then
	notify-send "Opening Chud Logic Twitch Stream"
	mpv --ytdl-format=best --title='Chud Logic - Twitch' https://www.twitch.tv/chudlogic || notify-send "Error, stream failed to open"
elif [[ "$1" == "nerdcubedTwitch" ]]; then
	notify-send "Opening NerdCubed Twitch Stream"
	mpv --ytdl-format=best --title='NerdCubed - Twitch' https://www.twitch.tv/nerdcubed || notify-send "Error, stream failed to open"
elif [[ "$1" == "dustinedenTwitch" ]]; then
	notify-send "Opening Dustin Eden Twitch Stream"
	mpv --ytdl-format=best --title='Dustin Eden - Twitch' https://www.twitch.tv/dustineden || notify-send "Error, stream failed to open"
elif [[ "$1" == "destinyRumble" ]]; then
	notify-send "Opening Destiny Rumble Stream"
	"$HOME/Programs/system/panel/destinyRumble.sh" || notify-send "Error, stream failed to open"
elif [[ "$1" == "noahsundayYouTube" ]]; then
	notify-send "Opening Noah Sunday YouTube Stream"
	mpv --ytdl-format=best --title='Noah Sunday - YouTube' https://www.youtube.com/@NoahSundayCompletionist/live || notify-send "Error, stream failed to open"
fi

