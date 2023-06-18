#!/usr/bin/env bash

changeMonospaceFont () {
	xfce4-appearance-settings & disown
	sleep 0.5
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

if [[ "$1" == "-d" ]]; then
	# Mousepad font
	changeMonospaceFont 1 1
	# Alacritty font
	sed -i -e 's/size: 7/size: 5/g' ~/.config/alacritty/alacritty.yml
elif [[ "$1" == "-l" ]]; then
	# Mousepad font
	changeMonospaceFont 1 3
	# Alacritty font
	sed -i -e 's/size: 5/size: 7/g' ~/.config/alacritty/alacritty.yml
elif [[ "$1" == "-s" ]]; then
	if grep -q "size: 7" ~/.config/alacritty/alacritty.yml; then
		~/Programs/system/keyboardOther/desktopMonitor.sh -d
	elif grep -q "size: 5" ~/.config/alacritty/alacritty.yml; then
		~/Programs/system/keyboardOther/desktopMonitor.sh -l
	fi
fi
