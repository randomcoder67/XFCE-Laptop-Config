#!/usr/bin/env bash

# Script to display uptime

uptimeFormatted=$(uptime | tr -s " " | cut -d " " -f 4 | grep -o [0-9:]*)

if [[ "${#uptimeFormatted}" == "4" ]]; then
	uptimeFormatted="0${uptimeFormatted}"
fi

echo "<txt> - ${uptimeFormatted}</txt>"
echo "<tool>Uptime</tool>"
