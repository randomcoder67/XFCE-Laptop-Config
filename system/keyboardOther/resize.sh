#!/usr/bin/env bash

# Script to resize windows in Xfce with keyboard shortcuts like a tiling window manager

windowID=$(xdotool getactivewindow)
windowGeometry=$(xdotool getwindowgeometry "$windowID")
geoX=$(echo "$windowGeometry" | sed -n "3p" | cut -d " " -f 4 | cut -d "x" -f 1)
geoY=$(echo "$windowGeometry" | sed -n "3p" | cut -d " " -f 4 | cut -d "x" -f 2)
posX=$(echo "$windowGeometry" | sed -n "2p" | cut -d " " -f 4 | cut -d "," -f 1)
posY=$(echo "$windowGeometry" | sed -n "2p" | cut -d " " -f 4 | cut -d "," -f 2)

if [[ "$1" == "decrease" ]]; then
	if [[ "$2" == "top" ]]; then
		newGeoY=$((geoY-20))
		newPosY=$((posY-38+29))
		newPosX=$((posX-5))
		xdotool windowsize "$windowID" "$geoX" "$newGeoY"
		xdotool windowmove "$windowID" "$newPosX" "$newPosY"
	elif [[ "$2" == "bottom" ]]; then
		newGeoY=$((geoY-20))
		xdotool windowsize "$windowID" "$geoX" "$newGeoY"
	elif [[ "$2" == "left" ]]; then
		newGeoX=$((geoX-20))
		newPosX=$((posX+15))
		newPosY=$((posY-29))
		xdotool windowsize "$windowID" "$newGeoX" "$geoY"
		xdotool windowmove "$windowID" "$newPosX" "$newPosY"
	elif [[ "$2" == "right" ]]; then
		newGeoX=$((geoX-20))
		xdotool windowsize "$windowID" "$newGeoX" "$geoY"
	fi
elif [[ "$1" == "increase" ]]; then
	if [[ "$2" == "top" ]]; then
		newGeoY=$((geoY+20))
		newPosY=$((posY-38-11))
		newPosX=$((posX-5))
		xdotool windowsize "$windowID" "$geoX" "$newGeoY"
		xdotool windowmove "$windowID" "$newPosX" "$newPosY"
	elif [[ "$2" == "bottom" ]]; then
		newGeoY=$((geoY+20))
		xdotool windowsize "$windowID" "$geoX" "$newGeoY"
	elif [[ "$2" == "left" ]]; then
		newGeoX=$((geoX+20))
		newPosX=$((posX-25))
		newPosY=$((posY-29))
		xdotool windowsize "$windowID" "$newGeoX" "$geoY"
		xdotool windowmove "$windowID" "$newPosX" "$newPosY"
	elif [[ "$2" == "right" ]]; then
		newGeoX=$((geoX+20))
		xdotool windowsize "$windowID" "$newGeoX" "$geoY"
	fi
elif [[ "$1" == "print" ]]; then
	echo "$windowGeometry"
fi
