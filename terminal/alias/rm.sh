#!/usr/bin/env bash

# rm script, allows deleting directories or files with same command, and changes rm to use trash-put. Also disallows rm ~ and rm /

if ! command -v trash-put &> /dev/null; then
    echo "Error: trash-cli not found. Please install it."
    echo "WARNING: trash-cli not installed, using rm as normal"
    rm "$@"
    exit
fi

for arg; do
	# Checks if you are trying to delete the home or root directory, if so, refuses
	if [ "$arg" == "$HOME" ] || [ "$arg" == "/" ]; then
		echo "nope bitch do it manually"
	else
		fileName=$arg
		if test -e "$fileName"; then # Check if file exists 
			if [ -d "$fileName" ]; then # Check if directory 
				if [ -z "$(ls -A "$fileName")" ]; then # Check if empty 
					read -p "rm: $fileName is an empty directory, do you want to delete (y/N) " uservar
						if [ "$uservar" == "y" ]; then
							trash-put -- "$fileName"
						fi
				else
					read -p "rm: $fileName is a directory (not empty), do you want to delete (y/N) " uservar
					if [ "$uservar" == "y" ]; then
							trash-put -- "$fileName"
					fi
				fi
			else
				read -p "rm: $fileName, do you want to delete (y/N) " uservar
				if [ "$uservar" == "y" ]; then
					trash-put -- "$fileName"
				fi
			fi
		else
			echo "File/Directory does not exist"
		fi
	fi
done
