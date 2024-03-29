#!/usr/bin/env bash

# Script to tile windows in Xfwm4

# Check if theme is dracula
if [ "$1" == "-d" ]; then
	draculaOffset=12
	draculaOffset2=6
else
	draculaOffset=0
	draculaOffset2=0
fi

# Get ID of current window 
curWindowID=$(printf 0x%x $(xdotool getactivewindow) | sed 's/0x/0x0/g')

# Get width and height of current window 
currentWindowGeo=$(wmctrl -lG | grep "$curWindowID" | tr -s ' ')
width=${currentWindowGeo#* * * * }
width=${width%% *}
height=${currentWindowGeo#* * * * * }
height=${height%% *}

# Get the list of windows on the current workspace with wmctrl
currentWorkspace=$(wmctrl -d | grep \* | tr -s " " | cut -d' ' -f10)
workspaceNum=" 0"
if [[ "$currentWorkspace" == "Sec" ]]; then
	workspaceNum=" 1"
fi
windows=$(wmctrl -lG | grep -P "^.{11}$workspaceNum" | tr -s ' ')

# Get the stack of windows
stack=( $(xprop -root | grep "STACKING(WINDOW)" | cut -d "#" -f 2 | tac -s ' ' | sed 's/,//g' | sed 's/0x/0x0/g') )

# Filter the stack array to only windows on the current desktop
stackFiltered=()
for x in "${stack[@]}"; do
	if [[ "$windows" = *"$x"* ]]; then
		stackFiltered+=("$x")
	fi
done

# If height is 1330, asjust horizontally, otherwise adjust vertically
if [[ "$height" == "1330" ]]; then
	expectedPosX=$((width+10+10-draculaOffset)) # The expected position of the window to the side is current + borders
	# Iterate through the filtered stack and find the first window in the expected position
	echo $expectedPosX
	for id in "${stackFiltered[@]}"; do
		curWindowInStack=$(echo "$windows" | grep "$id" | tr -s ' ')
		winWidth=${curWindowInStack#* * * * }
		winWidth=${winWidth%% *}
		winHeight=${curWindowInStack#* * * * * }
		winHeight=${winHeight%% *}
		winPosX=${curWindowInStack#* * }
		winPosX=${winPosX%% *}
		echo $id, $winPosX
		if [[ "$winHeight" == "1330" && "$winPosX" == "$expectedPosX" ]]; then
			matchingWindow="$curWindowInStack"
			break
		fi
		index=$((index+1))
	done
	# Get ID of matching window
	tiledWindowID=${matchingWindow%% *}
	
	if [[ "$2" == "" ]]; then
		# Stop xfwm4 from overwriting the move when changing workspaces
		wmctrl -r "$tiledWindowID" -i -b add,maximized_vert
		wmctrl -r "$curWindowID" -i -b add,maximized_vert
		# If the left window is expanding, make right window smaller then move it back to the edge
		xdotool windowsize "$tiledWindowID" "$((winWidth-40))" "$winHeight"
		xdotool windowmove "$tiledWindowID" "$((winPosX-10+40+draculaOffset2))" $((65-29))
		# Then make the left window bigger to fill the avalible space
		xdotool windowsize "$curWindowID" "$((width+40))" "$height"
	elif [[ "$2" == "-r" ]]; then
		# Stop xfwm4 from overwriting the move when changing workspaces
		wmctrl -r "$tiledWindowID" -i -b add,maximized_vert
		wmctrl -r "$curWindowID" -i -b add,maximized_vert
		# If the right window is expanding, make left window smaller then move it back to the edge
		xdotool windowsize "$curWindowID" "$((width-40))" "$height"
		xdotool windowmove "$curWindowID" "0" $((65-29))
		# Then make the right window bigger to fill the avalible space
		xdotool windowsize "$tiledWindowID" "$((winWidth+40))" "$height"
	fi
elif [[ "$width" == "1110" ]]; then
	echo width
fi
