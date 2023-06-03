#!/usr/bin/env bash

# Panel netdown down monitor 

filename="$HOME/Programs/output/.temp/networkDown.txt"

currentBytes=$(cat /sys/class/net/wlan0/statistics/rx_bytes)
previousBytes=$(cat "$filename")
echo "$currentBytes" > $filename

lastTwoSecs=$(echo "$currentBytes $previousBytes" | awk '{ final=($1-$2)/2/1000000 ; printf"<txt>%0.2f MB/s </txt>", final }')

echo "$lastTwoSecs"
