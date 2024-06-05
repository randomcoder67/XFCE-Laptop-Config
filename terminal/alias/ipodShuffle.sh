#!/usr/bin/env bash

# Script to syn my CurrentPlaylist folder with an iPod Shuffle 4th Gen

# Credit for iPod database python script: https://github.com/nims11/IPod-Shuffle-4g

driveLetter="a"

if [[ "$1" == "-b" ]]; then
	driveLetter="b"
fi

ipodMount="$HOME/Downloads/USBDrive"
ipodScriptLoc="$HOME/Programs/terminal/alias/ipod-shuffle-4g.py"

lsblk
echo "Mount /dev/sd${driveLetter} to ${ipodMount} and sync CurrentPlaylist folder?"
read -p "y/N: " confirmationVar

[[ "$confirmationVar" != "y" ]] && exit

echo "Mounting iPod to ${ipodMount}"
sudo mount -o rw,users,umask=000 "/dev/sd${driveLetter}" "${ipodMount}/"

echo "Deleting old music"
rm "${ipodMount}/iPod_Control/Music/MainMusic/"*.m4a

echo "Copying new music"
cp ~/Music/CurrentPlaylist/* "${ipodMount}/iPod_Control/Music/MainMusic/"

# NEED TO REMOVE NON ENGLISH CHARACTERS (korean etc)

echo "Building database"
python3 "${ipodScriptLoc}" -d -u "${ipodMount}/"

echo "Syncing and unmounting"
sync
sudo umount "/dev/sd${driveLetter}"

lsblk
echo "Done, safe to remove device"
