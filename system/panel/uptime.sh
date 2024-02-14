#!/usr/bin/env bash

# Script to display uptime

uptimeNormal=$(uptime | tr -s " ")
uptimeFormatted=$(echo "$uptimeNormal" | cut -d " " -f 4 | grep -o [0-9:]*)
uptimeSince="$(uptime -s)"

loadOneMinute=$(echo "$uptimeNormal" | cut -d " " -f 9 | grep -o [0-9.]*)
loadFiveMinutes=$(echo "$uptimeNormal" | cut -d " " -f 10 | grep -o [0-9.]*)
loadFifteenMinutes=$(echo "$uptimeNormal" | cut -d " " -f 11 | grep -o [0-9.]*)

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
