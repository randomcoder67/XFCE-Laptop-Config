#!/usr/bin/env bash

# Script to backup important files

# Set directories 
backupDir="$HOME/Downloads/BackupMount"
backupCurrent="$HOME/Programs/output/updated/backup.txt"
backupCurrentTemp="$HOME/Programs/output/updated/backupTemp.txt"
backup1="currentBackup"
backup2="backup2"
backup3="backup3"
hashHistory="hashHistory"
backupHistory="$HOME/Programs/output/updated/backupHistory.txt"

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
# Compare most recent backup to second most recent backup
elif [[ "$1" == "diff" ]]; then
	find ~/Downloads/BackupMount/hashHistory/ | sort | tail -n 2 | xargs diff --color
# Option to make new backup 
elif [[ "$1" == "make" ]]; then
	echo $(date +"%y%m%d %H:%M") >> "$backupHistory"
	echo "Making New Backup"
	# Copy previous 2nd backup to 3rd position 
	echo "Copying 2nd most recent backup to 3rd position"
	rsync --info=progress2 --recursive "$backupDir""/$backup2/" "$backupDir""/$backup3" --delete
	# Copy previous 1st backup to 2nd position 
	echo "Copying most recent backup to 2nd position"
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
	diff --color "$backupDir""/$backup1""/hashesBackup.txt" "$backupDir""/$backup1""/hashesOriginal.txt"
	
	echo "Saving hash files with timestamps"
	
	cp "$backupDir""/$backup1""/hashesOriginal.txt" "$backupDir""/$hashHistory""/original${fileNameDate}.txt"
	
	echo "Done!"
	#gpg -c "$backupDir""/$backup1""/hashesBackup.txt"
	#gpg -c "$backupDir""/$backup1""/hashesOriginal.txt"
elif [[ "$1" == "time" ]]; then
	if ! [ -f "$backupHistory" ]; then
		echo "No History File"
		exit
	fi
	curDate=$(date +"%y%m%d")
	oldIFS="$IFS"
	IFS=$'\n'
	if [[ "$2" == "-a" ]]; then
		times=( $(tac "$backupHistory") )
	else
		times=( $(tac "$backupHistory" | head -n 10) )
	fi
	for time in "${times[@]}"; do
		echo -n "${time/ / at }: "
		dateA=${time%% *}
		diffA=$(( ($(date --date="$curDate" +%s) - $(date --date="$dateA" +%s) )/(60*60*24) ))
		echo "${diffA} day(s) ago"
	done
# Option to list commands
else
	echo "Backup Program Usage:"
	echo "  backup - display this help information"
	echo "  backup make - make new backup"
	echo "  backup list/ls - list files to be backed up"
	echo "  backup add - add file/folder to backup list"
	echo "  backup remove - remove file/folder from backup list"
	echo "  backup diff - compare 2 most recent backups"
	echo "  backup time [-a] - list times of backups (defaults to showing last 10, -a to view all)"
fi
