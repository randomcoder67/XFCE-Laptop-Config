#!/usr/bin/env bash

backupDir="/mnt/backupDrive"
backupCurrent="$HOME/Programs/output/updated/backup.txt"
backup1="currentBackup"
backup2="backup2"
backup3="backup3"

if [[ "$1" == "add" ]]; then
	if [[ "$2" == "$HOME"* ]]; then
		fullFileName="$2"
		finalFileName="${fullFileName/$HOME/}"
		echo "$finalFileName" >> "$backupCurrent"
		exit
	fi
	fullFileName="$(pwd)/$2"
	finalFileName="${fullFileName/$HOME/}"
	echo "$finalFileName" >> "$backupCurrent"
	exit
elif [[ "$1" == "remove" ]]; then
	if [[ "$2" == "$HOME"* ]]; then
		fullFileName="$2"
		finalFileName="${fullFileName/$HOME/}"
		sed -i "\|^$finalFileName$|d" "$backupCurrent"
		exit
	fi
	fullFileName="$(pwd)/$2"
	finalFileName="${fullFileName/$HOME/}"
	sed -i "\|^$finalFileName$|d" "$backupCurrent"
	exit
elif [[ "$1" == "list" || "$1" == "ls" ]]; then
	cat "$backupCurrent" | awk '{print "~"$1}'
elif [[ "$1" == "make" ]]; then
	echo "doing backup"
	rsync --recursive "$backupDir""/$backup2/" "$backupDir""/$backup3" --delete
	rsync --recursive "$backupDir""/$backup1/" "$backupDir""/$backup2" --delete
	rm -rf "$backupDir""/$backup1/"*
	rsync --recursive --files-from="$backupCurrent" "$HOME" "$backupDir""/$backup1"
	oldIFS="$IFS"
	IFS=$'\n'

	files=( $(xargs -r -d'\n' -I{} find "$HOME"{} -type f < "$backupCurrent" | sort | uniq) )

	#rm "$backupDir""/$backup1""/hashesOriginal.txt"
	#rm "$backupDir""/$backup1""/hashesBackup.txt"

	for file in "${files[@]}"; do
		fileA=$(sha512sum "$file")
		echo "$fileA" >> "$backupDir""/$backup1""/hashesOriginal.txt"
	done

	files=( $(find "$backupDir/$backup1/" ! -name "hashesOriginal.txt" -type f | sort | uniq) )

	for file in "${files[@]}"; do
		fileA=$(sha512sum "$file")
		fileB="${fileA/$backupDir"/"$backup1/$HOME}"
		echo "$fileB" >> "$backupDir""/$backup1""/hashesBackup.txt"
	done

	diff "$backupDir""/$backup1""/hashesBackup.txt" "$backupDir""/$backup1""/hashesOriginal.txt"

	#gpg -c "$backupDir""/$backup1""/hashesBackup.txt"
	#gpg -c "$backupDir""/$backup1""/hashesOriginal.txt"
fi
