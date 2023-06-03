#!/usr/bin/env bash

# Script to add/remove programs to the rofiLauncher.sh script

command=$1
name=$2
run=$3

if [[ "$command" == "-a" ]]; then
	echo "$name"\;"$run" >> ~/Programs/output/updated/programs.txt
	read -p "Enter Icon File Name: " iconFileName
	echo echo\ -en\ \""$name\0icon\x1f/usr/share/icons/Papirus/32x32/apps/$iconFileName\n"\" >> ~/Programs/output/updated/programsIcons.sh
elif [[ "$command" == "-d" ]]; then
	sed -i "/$name/d" ~/Programs/output/updated/programs.txt
	sed -i "/$name/d" ~/Programs/output/updated/programsIcons.sh
fi

cat ~/Programs/output/updated/programs.txt | sort > ~/Programs/output/updated/programs2.txt
mv ~/Programs/output/updated/programs2.txt ~/Programs/output/updated/programs.txt

~/Programs/system/rofi/checkFiles.sh
