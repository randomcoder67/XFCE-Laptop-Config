#!/usr/bin/env bash

# Script to open ms in new window if one is open not in current workspace

SAVEIFS=$IFS # Save current IFS (Internal Field Separator)
IFS=$'\n'
done1="no"
listOfWindows+=()

if wmctrl -l | grep -q Mousepad; then
	currentWorkspace=$(wmctrl -d | grep \* | tr -s " " | cut -d' ' -f10)
	workspaceNum=0
	if [[ "$currentWorkspace" == "Sec" ]]; then
		workspaceNum=1
	fi
	openCur=($(wmctrl -l | grep -P ".{12}$workspaceNum"))

	for (( i=0; i<${#openCur[@]}; i++ ))
	do
		#echo "$i: ${openCur[$i]}"
		listOfNames+=( $(echo ${openCur[$i]} | grep Mousepad) )
	done
	if [[ "${#listOfNames[@]}" == 0 ]]; then
		for arg; do
			if [[ $done1 == "no" ]]; then
				mousepad -o window "$arg" & disown
				done1="yes"
			else
				#echo new
				mousepad "$arg" & disown
			fi
		done
	else
		id=$(echo $listOfNames | grep -P "0x.{8}")
		wmctrl -i -a $id
		for arg; do
			mousepad "$arg" & disown
		done
	fi
	#echo done
	for (( i=0; i<${#listOfNames[@]}; i++ ))
	do
		aa=9
		#echo "$i: ${listOfNames[$i]}"
	done
else
	for arg; do
		mousepad "$arg" & disown
	done
fi
IFS=$SAVEIFS
