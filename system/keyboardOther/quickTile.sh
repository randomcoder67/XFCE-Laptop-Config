#!/usr/bin/env bash

# Script to open Firefox and two terminals in predefined format

# Open windows
firefox & disown
alacritty & disown
alacritty & disown

sleep 1

currentWorkspace=$(wmctrl -d | grep \* | tr -s " " | cut -d' ' -f10)
workspaceNum=" 0"
if [[ "$currentWorkspace" == "Sec" ]]; then
	workspaceNum=" 1"
fi

windows=$(wmctrl -lG | grep -P "^.{11}$workspaceNum" | tr -s ' ')

# Get the stack of windows
stack=( $(xprop -root | grep "STACKING(WINDOW)" | cut -d "#" -f 2 | tac -s ',' | tr -d '\n' | sed 's/,//g' | sed 's/0x/0x0/g') )

# Filter the stack array to only windows on the current desktop
stackFiltered=()
for x in "${stack[@]}"; do
	if [[ "$windows" = *"$x"* ]]; then
		stackFiltered+=("${x/ /}")
	fi
done

doneA=0

wmctrl -lG
echo moving
for windowID in "${stackFiltered[@]}"; do
	echo $windowID
	wmctrl -r "$windowID" -i -b add,maximized_vert
	if echo "$windows" | grep "$windowID" | grep -i -q "firefox"; then
		wmctrl -r "$windowID" -i -b remove,maximized_vert
		xdotool windowsize "$windowID" 1476 1330
		xdotool windowmove "$windowID" 0 36
	elif [[ "$doneA" == 0 ]]; then
		xdotool windowsize "$windowID" 756 761
		xdotool windowmove "$windowID" 1480 36
		doneA=1
	else
		xdotool windowsize "$windowID" 756 538
		xdotool windowmove "$windowID" 1480 828
		break
	fi 
done

notify-send "Windows Arranged"
