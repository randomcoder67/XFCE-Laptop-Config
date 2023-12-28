#!/usr/bin/env bash

# Script to resize fonts when connecting or disconnecting from a monitor (necessary as my laptop is 1440p and any monitor I would connect to would be 1080p)

# Uses xdotool to change the monospace font size (for mousepad). Can't use xfconf-query as it won't updated the mousepad windows in real time
changeMonospaceFont () {
	xfce4-appearance-settings & disown
	sleep 0.5
	#xdotool key Left
	xdotool key Right Right Down
	sleep 0.1
	xdotool key Down
	sleep 0.1
	xdotool key Enter
	sleep 0.1
	xdotool key Tab
	sleep 0.1
	xdotool key Tab Tab Tab $1 $2 Tab Tab Enter Tab Tab Tab Tab Tab Tab Tab Enter
}

# -d means change to desktop mode 
if [[ "$1" == "-d" ]]; then
	# Mousepad font
	changeMonospaceFont 1 1
	# Alacritty font
	sed -i -e 's/size: 7/size: 11/g' ~/.config/alacritty/alacritty.yml
# -l means change to laptop mode
elif [[ "$1" == "-l" ]]; then
	# Mousepad font
	changeMonospaceFont 1 3
	# Alacritty font
	sed -i -e 's/size: 11/size: 7/g' ~/.config/alacritty/alacritty.yml
# -s means switch between modes
elif [[ "$1" == "-s" ]]; then
	# Check the alacritty.yml file to figure out which state computer is currently in
	if grep -q "size: 7" ~/.config/alacritty/alacritty.yml; then
		~/Programs/system/keyboardOther/desktopMonitor.sh -d
	elif grep -q "size: 11" ~/.config/alacritty/alacritty.yml; then
		~/Programs/system/keyboardOther/desktopMonitor.sh -l
	fi
fi
