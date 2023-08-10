#!/usr/bin/env bash

# Set directories 
backupDir="$HOME/Downloads/BackupMount"
backupCurrent="$HOME/Programs/output/updated/backup.txt"
backupCurrentTemp="$HOME/Programs/output/updated/backupTemp.txt"
backup1="currentBackup"
backup2="backup2"
backup3="backup3"
hashHistory="hashHistory"

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
	sort "$backupCurrent" > "$backupCurrentTemp"
	mv "$backupCurrentTemp" "$backupCurrent"
	exit
# Option to remove a file or directory from backup
elif [[ "$1" == "remove" || "$1" == "rm" ]]; then
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
# Option to sort current backup file (serves no real purpose, just looks nicer when it's listed
elif [[ "$1" == "sort" ]]; then
	sort "$backupCurrent" > "$backupCurrentTemp"
	mv "$backupCurrentTemp" "$backupCurrent"
# Option to list commands
elif [[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]]; then
	echo "Backup Program Usage:"
	echo "  backup help - display this help information"
	echo "  backup make - make new backup"
	echo "  backup list/ls - list files to be backed up"
	echo "  backup add - add file/folder to backup list"
	echo "  backup remove - remove file/folder from backup list"
# Option to make new backup 
elif [[ "$1" == "make" ]]; then
	echo "Making New Backup"
	# Copy previous 2nd backup to 3rd position 
	echo "Copying 2nd most recent backup to 3rd position"
	rsync --info=progress2 --recursive "$backupDir""/$backup2/" "$backupDir""/$backup3" --delete
	# Copy previous 1st backup to 2nd position 
	echo "Copying most recent backup to 2rd position"
	rsync --info=progress2 --recursive "$backupDir""/$backup1/" "$backupDir""/$backup2" --delete
	# Remove previous first backup to make way for new one (this is t ensure no removed directories/files are included) 
	# Remove the directory instead of contents to ensure all hidden directories are removed 
	rm -rf "$backupDir""/$backup1"
	# Remake the directory 
	mkdir "$backupDir""/$backup1"
	# Make new 1st backup 
	echo "Backing up current files"
	rsync --info=progress2 --recursive --files-from="$backupCurrent" "$HOME" "$backupDir""/$backup1"
	oldIFS="$IFS"
	IFS=$'\n'

	# Hash the files on the computer and on the backup, compare them to ensure perfect backup and save the hashes to a file for future integrity checking 
	files=( $(xargs -r -d'\n' -I{} find "$HOME"{} -type f < "$backupCurrent" | sort | uniq) )

	#rm "$backupDir""/$backup1""/hashesOriginal.txt"
	#rm "$backupDir""/$backup1""/hashesBackup.txt"
	
	echo "Hashing files on computer"
	for file in "${files[@]}"; do
		fileA=$(sha512sum "$file")
		echo "$fileA" >> "$backupDir""/$backup1""/hashesOriginal.txt"
	done

	files=( $(find "$backupDir/$backup1/" ! -name "hashesOriginal.txt" -type f | sort | uniq) )

	fileNameDate=$(date +"%y%m%d%H%M")
	
	echo "Hashing files on backup drive"
	for file in "${files[@]}"; do
		fileA=$(sha512sum "$file")
		fileB="${fileA/$backupDir"/"$backup1/$HOME}"
		echo "$fileB" >> "$backupDir""/$backup1""/hashesBackup.txt"
		echo "$fileA" >> "$backupDir""/$hashHistory""/backup${fileNameDate}.txt"
	done

	echo "Comparing hashes"
	diff "$backupDir""/$backup1""/hashesBackup.txt" "$backupDir""/$backup1""/hashesOriginal.txt"
	
	echo "Saving hash files with timestamps"
	
	cp "$backupDir""/$backup1""/hashesOriginal.txt" "$backupDir""/$hashHistory""/original${fileNameDate}.txt"
	
	echo "Done!"
	#gpg -c "$backupDir""/$backup1""/hashesBackup.txt"
	#gpg -c "$backupDir""/$backup1""/hashesOriginal.txt"
fi
