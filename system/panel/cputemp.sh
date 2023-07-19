#!/usr/bin/env bash

# Panel CPU Temperature monitor
DEBUG=0

CPUTEMP=$(sensors | grep -Eo 'Package id 0:.{0,10}' | grep -Eo '[1-9].{0,1}' | sed 's/$/°C/')
if [[ "$CPUTEMP" == "" ]]; then
	CPUTEMP=$(sensors | grep CPUTIN | grep -Eo '[1-9].{3}' | head -1 | awk '{ printf"%0.0f", $1}' | sed 's/$/°C/')
fi


echo "<txt>$CPUTEMP </txt><txtclick>alacritty -e btop</txtclick>"
echo "<tool>btop</tool>"

exit 0
