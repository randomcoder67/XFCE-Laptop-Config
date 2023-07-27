#!/usr/bin/env bash

switch=$(cat ~/a.txt)

if [[ "$switch" == "on" ]]; then
	echo "off" > ~/a.txt
	xdotool keyup 66
else
	echo "on" > ~/a.txt
	xdotool keydown 66
fi
