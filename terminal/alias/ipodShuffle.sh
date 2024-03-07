#!/usr/bin/env bash

# Script to syn my CurrentPlaylist folder with an iPod Shuffle 4th Gen

# Credit for iPod database python script: https://github.com/nims11/IPod-Shuffle-4g

ipodMount="$HOME/Downloads/USBDrive"
ipodScriptLoc="$HOME/Programs/terminal/alias/ipod-shuffle-4g.py"

lsblk
echo "Mount /dev/sda to ${ipodMount} and sync CurrentPlaylist folder?"
read -p "y/N: " confirmationVar

[[ "$confirmationVar" != "y" ]] && exit

echo "Mounting iPod to ${ipodMount}"
sudo mount -o rw,users,umask=000 /dev/sda "${ipodMount}/"

echo "Deleting old music"
rm "${ipodMount}/iPod_Control/Music/"*.m4a

echo "Copying new music"
cp ~/Music/CurrentPlaylist/* "${ipodMount}/iPod_Control/Music/"

# NEED TO REMOVE NON ENGLISH CHARACTERS (korean etc)

echo "Building database"
python3 "${ipodScriptLoc}" "${ipodMount}/"

echo "Syncing and unmounting"
sync
sudo umount /dev/sda

lsblk
echo "Done, safe to remove device"
