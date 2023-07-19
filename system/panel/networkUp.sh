#!/usr/bin/env bash

# Panel network up monitor 

# Set filename
filename="$HOME/Programs/output/.temp/networkUp.txt"

# wlan0 may need to be changed to your wireless adapter name
currentBytes=$(cat /sys/class/net/wlp8s0f3u3/statistics/tx_bytes)
previousBytes=$(cat "$filename")
echo "$currentBytes" > $filename

# Do calculation
lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1000000 ; printf"<txt>%0.2f MB/s </txt>", final }')

echo "$lastTwoSecs"
