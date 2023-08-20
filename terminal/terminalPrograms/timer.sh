#!/usr/bin/env bash

# Simple bash timer

# Print help
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "help" ]]; then
	echo "Usage:"
	echo "  timer [-m] [num secs/mins]"
	exit
fi

# Get total time, and if "-m" option given, convert minutes to seconds
timeTotal="$1"
if [[ "$1" == "-m" ]]; then
	secondArg="$2"
	timeTotal=$((secondArg*60))
	echo "Setting timer for $secondArg minute(s)"
else
	echo "Setting timer for $timeTotal second(s)"	
fi

# Do timer
for i in $(seq $timeTotal); do
	sleep 1
	echo -e "Time Remaining: $((timeTotal-i)) secs		  
	\e[2A"
done
# Echo empty line to put prompton correct line
echo ""

# Send notification
notify-send "Timer Finished"

# Make alarm sound
/usr/bin/mpv --really-quiet "$HOME/Programs/output/.sounds/alarm.m4a" --no-resume-playback & disown
