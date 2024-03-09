#!/usr/bin/env bash

# mv using trash-cli

command=""
if [[ "$1" == "-c" ]]; then
	command="cp"
elif [[ "$1" == "-m" ]]; then
	command="mv"
else
	exit
fi

if [ "$#" -lt 3 ]; then
	echo "Usage:"
	echo "  $command [-t] source dest"
	exit
fi

if [[ "$2" == "-t" ]]; then
	if ! test -e "$3"; then
		echo "Destination folder does not exist"
		exit
	fi
	dest="$3"
	i=0
	for arg; do
		i="$((i+1))"
		if [ $i -lt 4 ]; then
			continue
		fi
		if ! test -e "${dest}/$arg"; then
			"$command" "$arg" "${dest}/"
		else
			read -p "Destination already exists, overwrite (y/N) " confirmationVar
			if [[ "$confirmationVar" == "y" ]]; then
				trash-put "${dest}/${arg}"
				"$command" "$arg" "${dest}/"
			fi
		fi
	done
else
	if ! test -e "$2"; then
		echo "Source does not exist"
		exit
	fi 
	
	dest="$3"
	if [ -d "$dest" ]; then
		dest="${dest}/$2"
	fi
	if ! test -e "$dest"; then
		"$command" "$2" "$dest"
	else
		read -p "Destination already exists, overwrite (y/N) " confirmationVar
		if [[ "$confirmationVar" == "y" ]]; then
			trash-put "$dest"
			"$command" "$2" "$dest"
		fi
	fi
fi
