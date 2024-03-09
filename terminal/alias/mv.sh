#!/usr/bin/env bash

# mv using trash-cli

# Check for trash-cli
if ! command -v trash-put &> /dev/null; then
    echo "Error: trash-cli not found. Please install it."
    exit 1
fi

command=""
command2=""
if [[ "$1" == "-c" ]]; then
	command="cp"
	command2="-r"
elif [[ "$1" == "-m" ]]; then
	command="mv"
else
	exit 1
fi

if [ "$#" -lt 3 ]; then
	echo "Usage:"
	echo "  $command [-t] source dest"
	exit 1
fi

if [[ "$2" == "-t" ]]; then
	if ! test -e "$3"; then
		echo "Destination folder does not exist"
		exit 1
	fi
	dest="$3"
	i=0
	for arg; do
		i="$((i+1))"
		if [ $i -lt 4 ]; then
			continue
		fi
		if ! test -e "${dest}/$arg"; then
			"$command" "$command2" "$arg" "${dest}/"
		else
			read -p "Destination already exists, overwrite (y/N) " confirmationVar
			if [[ "$confirmationVar" == "y" ]]; then
				trash-put -- "${dest}/${arg}"
				"$command" "$command2" "$arg" "${dest}/"
			fi
		fi
	done
else
	if ! test -e "$2"; then
		echo "Source does not exist"
		exit 1
	fi
	
	ogDest="${@: -1}"
	i=0
	for arg; do
		dest="$ogDest"
		i="$((i+1))"
		if [ $i -lt 2 ]; then
			continue
		elif [ $((i+1)) -gt "$#" ]; then
			break
		fi
		
		if [ -d "$dest" ]; then
			dest="${dest}/${arg##*/}"
		fi
		
		if ! test -e "$dest"; then
			"$command" "$command2" "$arg" "$dest"
		else
			read -p "Destination already exists, overwrite (y/N) " confirmationVar
			if [[ "$confirmationVar" == "y" ]]; then
				trash-put -- "$dest"
				"$command" "$command2" "$arg" "$dest"
			fi
		fi
	done
fi
