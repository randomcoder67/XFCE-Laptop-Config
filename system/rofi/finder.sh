#!/usr/bin/env bash

# rofi finder script, not mine (credit: https://github.com/davatorium/rofi-scripts/blob/master/rofi-finder/finder.sh)

#PUT THIS FILE IN ~/.local/share/rofi/finder.sh
#USE: rofi  -show find -modi find:~/.local/share/rofi/finder.sh
if [ ! -z "$@" ]
then
	QUERY=$@
	if [[ "$@" == /* ]]
	then
		if [[ "$@" == *\?\? ]]
		then
			coproc ( exo-open "${QUERY%\/* \?\?}"  > /dev/null 2>&1 )
			exec 1>&-
			exit;
		else
			coproc ( exo-open "$@"  > /dev/null 2>&1 )
			exec 1>&-
			exit;
		fi
	elif [[ "$@" == \!\!* ]]
	then
		echo "!!-- Type your search query to find files"
		echo "!!-- To search again type !<search_query>"
		echo "!!-- To search parent directories type ?<search_query>"
		echo "!!-- You can print this help by typing !!"
	elif [[ "$@" == \?* ]]
	then
		echo "!!-- Type another search query"
		while read -r line; do
		echo "$line" \?\?
		done <<< $(find ~ -type d -path '*/\.*' -prune -o -type f -iname *"${QUERY#\?}"* -print)
	else
		echo "!!-- Type another search query"
		find ~ -type d -path '' -prune -o -type f -iname *"${QUERY#!}"* -print
	fi
else
	echo "!!-- Type your search query to find files"
	echo "!!-- To seach again type !<search_query>"
	echo "!!-- To seach parent directories type ?<search_query>"
	echo "!!-- You can print this help by typing !!"
fi
