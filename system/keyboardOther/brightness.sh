#!/usr/bin/env bash

# Script to change brightness
# https://forum.xfce.org/viewtopic.php?id=16187

current="$(cat /sys/class/backlight/intel_backlight/brightness)"
max="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
idFile="$HOME/Programs/output/.temp/brightnessNotifiationId"
if [ -f "$idFile" ]; then
	oldNotificationId=$(cat "$idFile")
else
	oldNotificationId="1000"
fi

#echo "Current: ${current}"

function get_percentage() {
	precise=$(echo "$1/$2*100" | bc -l)
	rounded=$(printf "%0.0f" $precise)
	echo "$rounded"
}

function get_icon_name() {
	if [[ "$1" -lt "30" ]]; then
		echo "brightness-low-symbolic"	
	elif [[ "$1" -lt "70" ]]; then
		echo "brightness-medium-symbolic"	
	else
		echo "brightness-high-symbolic"	
	fi
}

function set_brightness() {
	#echo "Setting to: ${1}"
	echo "$1" | sudo /usr/bin/tee "/sys/class/backlight/intel_backlight/brightness"
	
	percentage="$(get_percentage $1 $max)"
	iconName="$(get_icon_name $percentage)"
	newId=$(notify-send "Brightness" -p -r "$oldNotificationId" -i $iconName -h int:value:"$percentage")
	echo "$newId" > "$idFile"
}

if [[ "$1" == "--down" ]]; then
	[[ "$current" == "0" ]] && exit
	[[ "$current" -lt 1500 ]] && set_brightness 0 && exit
	toSet=$((current-1500))
	set_brightness "$toSet"
elif [[ "$1" == "--up" ]]; then
	[[ "$current" == "$max" ]] && exit
	nearlyMax=$((max-1500))
	[[ "$current" -gt "$nearlyMax" ]] && set_brightness "$max" && exit
	toSet=$((current+1500))
	set_brightness "$toSet"
fi
