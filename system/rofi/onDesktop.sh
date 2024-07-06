#!/usr/bin/env bash

# Simple script using wmctrl to check if a given program is open on the currently visible desktop

if [[ "$1" == "" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	echo "Usage: ./onDesktop.sh [-q] programname"
	echo "  -q - Set exit code to boolean of result instead of printing result"
	exit
fi

programName="$1"
output="text"

if [[ "$1" == "-q" ]]; then
	if [[ "$2" == "" ]]; then
		echo "Usage: ./onDesktop.sh [-q] programname"
		echo "  -q - Set exit code to boolean of result instead of printing result"
		exit
	fi
	programName="$2"
	output="status"
fi

desktopNum="$(wmctrl -d | grep \* | tr -s ' ' | cut -d ' ' -f 1)"
wmctrl -lG | tr -s " " | cut -d " " -f 2- | grep "^$desktopNum" | grep -q -i "$programName"
status="$?"

if [[ "$output" == "text" ]]; then
	if [[ "$status" == "0" ]]; then
		echo "true"
	else
		echo "false"
	fi
fi
exit $status
