#!/usr/bin/env bash

# rm script, allows deleting directories or files with same command, and changes rm to use trash-put. Also disallows rm ~

for arg; do
	if [ "$arg" == "$HOME" ] || [ "$arg" == "/" ]; then
		echo "nope bitch do it manually"
	else
		fileName=$arg
		if test -e "$fileName"; then
			if [ -d "$fileName" ]; then
				if [ -z "$(ls -A "$fileName")" ]; then
					read -p "rm: $fileName is an empty directory, do you want to delete (y/n) " uservar
						if [ "$uservar" == "y" ]; then
							trash-put "$fileName"
						fi
				else
					read -p "rm: $fileName is a directory (not empty), do you want to delete (y/n) " uservar
					if [ "$uservar" == "y" ]; then
							trash-put "$fileName"
					fi
				fi
			else
				read -p "rm: $fileName, do you want to delete (y/n) " uservar
				if [ "$uservar" == "y" ]; then
					trash-put "$fileName"
				fi
			fi
		else
			echo "File/Directory does not exist"
		fi
	fi
done
