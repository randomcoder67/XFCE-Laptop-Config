#!/usr/bin/env bash

# Script to display uptime

uptimeNormal=$(uptime | tr -s " ")
uptimeFormatted=$(echo "$uptimeNormal" | cut -d " " -f 4 | grep -o [0-9:]*)
uptimeSince="$(uptime -s)"

targetSplit="9"
loadOneMinute=$(echo "$uptimeNormal" | cut -d " " -f "$targetSplit" | grep -o [0-9.]*)
# Sometimes there is an extra item in the split, because of "min" text
if [[ "$loadOneMinute" == "" ]]; then
	targetSplit="10"
	loadOneMinute=$(echo "$uptimeNormal" | cut -d " " -f "$targetSplit" | grep -o [0-9.]*)
fi
targetSplit=$((targetSplit+1))
loadFiveMinutes=$(echo "$uptimeNormal" | cut -d " " -f "$targetSplit" | grep -o [0-9.]*)
targetSplit=$((targetSplit+1))
loadFifteenMinutes=$(echo "$uptimeNormal" | cut -d " " -f "$targetSplit" | grep -o [0-9.]*)

if [[ "${#uptimeFormatted}" == "4" ]]; then
	uptimeFormatted="0${uptimeFormatted}"
elif [[ "${#uptimeFormatted}" == "2" ]]; then
	uptimeFormatted="00:${uptimeFormatted}"
elif [[ "${#uptimeFormatted}" == "1" ]]; then
	uptimeFormatted="00:0${uptimeFormatted}"
fi

echo "<txt> - ${uptimeFormatted}</txt>"
echo "<tool>Uptime Details
Up Since: ${uptimeSince}
Load Average (1m): ${loadOneMinute}
Load Average (5m): ${loadFiveMinutes}
Load Average (15m): ${loadFifteenMinutes}</tool>"
