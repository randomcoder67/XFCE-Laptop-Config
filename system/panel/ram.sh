#!/usr/bin/env bash

# Panel RAM usage monitor

DEBUG=0

MEMUSAGE2=$(free -m | awk '/^Mem/ {print $3}')
THOUSAND=$(echo 1024)
MEMUSAGE=$(echo "scale=1; $MEMUSAGE2/$THOUSAND" | bc)

#echo "${MEMUSAGE: -1}"
#toTest="${MEMUSAGE: -1}"
if (( $MEMUSAGE2 < 1024 ))
then
	MEMUSAGE=0$MEMUSAGE
fi

echo "<txt>$MEMUSAGE GiB </txt><txtclick>alacritty -e htop</txtclick>"
echo "<tool>htop</tool>"

exit 0
