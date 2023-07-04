#!/usr/bin/env bash

# Set directories 
backupDir="$HOME/Downloads/BackupMount"
backupCurrent="$HOME/Programs/output/updated/backup.txt"
backup1="currentBackup"
backup2="backup2"
backup3="backup3"

# Option to add a file or directory to backup
if [[ "$1" == "add" ]]; then
	if [[ "$2" == "$HOME"* ]]; then
		fullFileName="$2"
		finalFileName="${fullFileName/$HOME/}" # Remove $HOME prefix
		echo "$finalFileName" >> "$backupCurrent"
		exit
	fi
	fullFileName="$(pwd)/$2" # Gets full file path if the given one was relative
	finalFileName="${fullFileName/$HOME/}"
	echo "$finalFileName" >> "$backupCurrent"
	exit
# Option to remove a file or directory from backup
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
# Option to list currently backed up files and directories 
elif [[ "$1" == "list" || "$1" == "ls" ]]; then
	cat "$backupCurrent" | awk '{print "~"$1}'
# Option to make new backup 
elif [[ "$1" == "make" ]]; then
	echo "doing backup"
	# Copy previous 2nd backup to 3rd position 
	rsync --recursive "$backupDir""/$backup2/" "$backupDir""/$backup3" --delete
	# Copy previous 1st backup to 2nd position 
	rsync --recursive "$backupDir""/$backup1/" "$backupDir""/$backup2" --delete
	# Remove previous first backup to make way for new one (this is t ensure no removed directories/files are included) 
	rm -rf "$backupDir""/$backup1/"*
	# Make new 1st backup 
	rsync --recursive --files-from="$backupCurrent" "$HOME" "$backupDir""/$backup1"
	oldIFS="$IFS"
	IFS=$'\n'

	# Hash the files on the computer and one the backup, compare them to ensure perfect backup and save the hashes to a file for future integrity checking 
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
