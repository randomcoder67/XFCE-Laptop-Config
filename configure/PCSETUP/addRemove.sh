#!/usr/bin/env bash

# Script to add/remove programs to the rofiLauncher.sh script

command=$1
name=$2
run=$3

if [[ "$command" == "-a" ]]; then
	# Add name and command to the programs.txt file
	echo "$name"\;"$run" >> ~/Programs/output/updated/programs.txt
	# Get the icon name and add it to the programsIcons.sh script
	read -p "Enter Icon File Name: " iconFileName
	echo echo\ -en\ \""$name\0icon\x1f/usr/share/icons/Papirus/24x24/apps/$iconFileName\n"\" >> ~/Programs/output/updated/programsIcons.sh
elif [[ "$command" == "-d" ]]; then
	# Delete an entry from programs.txt and programsIcons.sh
	sed -i "/$name/d" ~/Programs/output/updated/programs.txt
	sed -i "/$name/d" ~/Programs/output/updated/programsIcons.sh
elif [[ "$command" == "-h" ]]; then
	echo "Usage:"
	echo "  programs -a name commandName - Add entry"
	echo "  programs -d name/commandName - Delete entry"
fi

# Re sort the programs.txt file
sort ~/Programs/output/updated/programs.txt > ~/Programs/output/updated/programs2.txt
mv ~/Programs/output/updated/programs2.txt ~/Programs/output/updated/programs.txt

# Re sort the programsIcons.sh file
sort ~/Programs/output/updated/programsIcons.sh > ~/Programs/output/updated/programsIcons2.sh
mv ~/Programs/output/updated/programsIcons2.sh ~/Programs/output/updated/programsIcons.sh

# Make the programsIcons.sh file executable 
chmod +x ~/Programs/output/updated/programsIcons.sh

# Rerun checkfiiles.sh to updated Rofi Launcher 
~/Programs/system/rofi/checkFiles.sh
