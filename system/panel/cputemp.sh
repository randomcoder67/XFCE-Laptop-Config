#!/usr/bin/env bash

# Panel CPU Temperature monitor
DEBUG=0

CPUTEMP=$(sensors | grep -Eo 'Package id 0:.{0,10}' | grep -Eo '[1-9].{0,1}' | sed 's/$/°C/')

echo "<txt>$CPUTEMP </txt><txtclick>alacritty -e btop</txtclick>"
echo "<tool>btop</tool>"

exit 0
