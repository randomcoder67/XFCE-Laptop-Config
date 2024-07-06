#!/usr/bin/env sh

# Script to mount USB devices, presents commonly used options

driveLetter="a"
if [[ "$1" == "-l" ]]; then
	if [[ "$2" == "" ]]; then
		echo "Error, specify drive letter after -l"
		exit
	fi
	driveLetter="$2"
fi

# Display disks to user
lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
# Prompt for option
echo "Select Option to Mount:"
echo "1. /dev/sd${driveLetter}1 -> ~/Downloads/BackupMount"
echo "2. /dev/sd${driveLetter}1 -> ~/Downloads/USBDrive"
echo "3. /dev/sd${driveLetter}1 -> ~/Downloads/USBDrive (FAT)"
echo "4. /dev/sd${driveLetter} -> ~/Downloads/USBDrive"
echo "5. /dev/sd${driveLetter} -> ~/Downloads/USBDrive (FAT)"
echo "6. Unmount"
read -p "Enter option (q to quit): " inputVar
# Check for q or blank and exit
[ "$inputVar" == "" ] || [ "$inputVar" == "q" ] && exit

# Handle given option
[ "$inputVar" == "1" ] && sudo mount "/dev/sd${driveLetter}1" ~/Downloads/BackupMount
[ "$inputVar" == "2" ] && sudo mount "/dev/sd${driveLetter}1" ~/Downloads/USBDrive
[ "$inputVar" == "3" ] && sudo mount -o rw,users,umask=000 "/dev/sd${driveLetter}1" ~/Downloads/USBDrive
[ "$inputVar" == "4" ] && sudo mount "/dev/sd${driveLetter}" ~/Downloads/USBDrive
[ "$inputVar" == "5" ] && sudo mount -o rw,users,umask=000 "/dev/sd${driveLetter}" ~/Downloads/USBDrive
if [ "$inputVar" == "6" ]; then
	mounted=$(lsblk | grep "sd${driveLetter}" | grep -E "part|disk /" | cut -d " " -f 1 | tr -d "└─")
	[[ "$mounted" == "" ]] && exit
	sudo umount "/dev/$mounted"
fi

lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS
