#!/usr/bin/env bash

# Makes collage of all album art in directory

IFS=$'\n'
files=( $(find . -maxdepth 1 | grep -v ".aGay" | grep -vP "^.$") ) # Get files excluding useless stuff

mkdir -p art/art2 # Make directories (after getting files so they aren't in the files array)

for i in ${!files[@]}; do # Extract album art
	ffmpeg -i "${files[$i]}" -an -c:v copy art/$i.jpg 2>/dev/null >> /dev/null
done

if [[ $1 == "-d" ]]; then # Checking for duplicates
	declare -A filesChecking
	for i in ${!files[@]}; do
		hash=$(sha256sum "art/$i.jpg" | cut -d " " -f1)
		filesChecking["$hash"]="art/$i"
	done
fi

#for x in "${!filesChecking[@]}"; do printf "[%q]=%q\n" "$x" "${filesChecking[$x]}" ; done

if [[ $1 == "-d" ]]; then
	for x in "${!filesChecking[@]}"; do
		convert "${filesChecking[$x]}".jpg -resize 1400x1400 art/"$(echo ${filesChecking[$x]} | sed -r 's/art/art2/g')".jpg
	done
else
	convert art/*.jpg -resize 1400x1400 art/art2/*.jpg
fi
montage -tile 0x0 -geometry +0+0 art/art2/*.jpg art/art2/output.jpg
ristretto art/art2/output.jpg
rm -rf ./art
