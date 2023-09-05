#!/usr/bin/env bash

# Panel network down monitor 

# Set filename
filename="$HOME/Programs/output/.temp/networkDown.txt"

# wlan0 may need to be changed to your wireless adapter name
currentBytes=$(cat /sys/class/net/wlp0s20f3/statistics/rx_bytes)
previousBytes=$(cat "$filename")
echo "$currentBytes" > $filename

lastTwoSecs=" "

# Do calculation, ensuring final value only has 3 digits so width is maintained
if (( $(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2) ; printf"%d", final }') > 19990000 )); then
	lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1000000 ; printf"<txt>%0.1f MB/s </txt>", final }')
else
	lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1000000 ; printf"<txt>%0.2f MB/s </txt>", final }')
fi

echo "$lastTwoSecs<txtclick>alacritty -e nethogs</txtclick>"
echo "<tool>NetHogs</tool>"
