#!/usr/bin/env bash

# Makes collage of all album art in directory

tempDirectory="$HOME/Programs/output/.temp/" # Set directory to store the files while you view them

IFS=$'\n'
files=( $(find "$HOME/Music/CurrentPlaylist" -mindepth 1 | grep -vP "^.$") ) # Get files excluding useless stuff

mkdir -p "${tempDirectory}art/art2" # Make directories

for i in ${!files[@]}; do # Extract album art
	ffmpeg -i "${files[$i]}" -an -c:v copy "${tempDirectory}art/$i.jpg" 2>/dev/null >> /dev/null
done

if [[ $1 == "-d" ]]; then # Checking for duplicates
	declare -A filesChecking
	for i in ${!files[@]}; do
		hash=$(sha256sum "${tempDirectory}art/$i.jpg" | cut -d " " -f1)
		filesChecking["$hash"]="${tempDirectory}art/$i"
	done
fi

#for x in "${!filesChecking[@]}"; do printf "[%q]=%q\n" "$x" "${filesChecking[$x]}" ; done

# Convert files 
if [[ $1 == "-d" ]]; then
	for x in "${!filesChecking[@]}"; do
		convert "${filesChecking[$x]}".jpg -resize 1400x1400 "${tempDirectory}art/art2/$(echo ${filesChecking[$x]} | cut -d "/" -f 8)".jpg
	done
else
	convert "${tempDirectory}"art/*.jpg -resize 1400x1400 "${tempDirectory}"art/art2/*.jpg
fi
# Create final images
montage -tile 0x0 -geometry +0+0 "${tempDirectory}"art/art2/*.jpg "${tempDirectory}"art/art2/output.jpg
# Display image 
ristretto "${tempDirectory}"art/art2/output.jpg
# Once user quits ristretto, delete the temp directories
rm -rf "$tempDirectory"/art
