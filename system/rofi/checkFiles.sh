#!/usr/bin/env bash

#SAVEIFS=$IFS # Save current IFS (Internal Field Separator)
#IFS=$'\n'

#for i in ${!listOfFiles[@]}; do # Tag
#	echo $i "${listOfFiles[$i]}"
#done

#IFS=$SAVEIFS

IFS=$'\n'

rm ~/Programs/output/updated/files.txt

#for x in "${programs[@]}"; do
#	first=$(echo "$x" | cut -d\; -f1)
#	echo "$first" >> ~/Programs/output/updated/files.txt
#done

# Add programs (with icons) first so they will be at the start 
~/Programs/output/updated/programsIcons.sh > ~/Programs/output/updated/filesFinal.txt

# Find files in main folders and .config 
find ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos ~/Desktop ~/Programs ~/.config -mount -mindepth 1 -type f | sed 's|'"${HOME}"'|~|g' | grep -P "[.]csv$|[.]txt$|mp3$|[.]m4a$|mp4$|[.]webm$|[.]mov$|[.]avi$|[.]png$|[.]webp$|[.]jpg$|[.]jpeg$|[.]inputrc$|[.]xml$|[.]css$|[.]md$|[.]rc$|[.]json$|[.]sh$|[.]git$|[.]conf$|[.]py$|[.]rasi$|[.]mk$|[.]h$|[.]desktop$|[.]AppImage$|[.]crt$|[.]bash$|[.]config$|[.]log$|[.]tmp$|[.]ini$|[.]old$|[.]code$|[.]backup$|[.]vscdb$|[.]haskell$|[.]c$|[.]cnf$|[.]hs$|[.]groff$|[.]java$|[.]dat$|[.]js$|[.]gif$|[.]html$|json~$|[.]bak$|[.]ico$|[.]svg$|[.]yml$|[.]cache$|[.]po$|[.]Po$|[.]ac$|[.]m$|[.]install$|[.]x$|[.]y$|[.]cabal$|[.]mdown$|[.]markdown$|[.]micro$|[.]toml$|[.]orig$|[.]yaml$|[.]README$|[.]bat$|[.]cpp$|[.]pl$|[.]app$|[.]icns$|[.]man$|[.]fish$|[.]rtf$|[.]cc$|[.]d$|[.]vscode$|[.]ghc$|[.]sys$|[.]ssh$|[.]pub$|[.]xinitrc$|[.]srt$|[.]kdenlive$|[.]aac$|[.]vtt$|[.]wav$|[.]ma$|[.]mkv$|[.]mozilla$|[.]dmp$|[.]co$|[.]ghcup$|[.]nanorc$|[.]pki$|[.]themes$|[.]gpg$|[.]tar$|[.]gitconfig$|[.]profile$|[.]s$|[.]dmrc$|[.]nano$|[.]bashrc$|[.]lesshst$|[.]xpm$|[.]xbm$|[.]styles$|[.]layout$|[.]menu$|[.]doc$|[.]htm$|[.]ogg$|[.]bmp$|[.]ods$|[.]out$|[.]ms$|[.]cfg$|[.]lua$|[.]go$|[.]gpx$|[.]lang$|[.]m4v$" >> ~/Programs/output/updated/files.txt
# Find files in home directory without going into folders
find ~ -mount -maxdepth 1 -type f | sed 's|'"${HOME}"'|~|g' | grep -P "[.]csv$|[.]txt$|mp3$|[.]m4a$|mp4$|[.]webm$|[.]mov$|[.]avi$|[.]png$|[.]webp$|[.]jpg$|[.]jpeg$|[.]inputrc$|[.]xml$|[.]css$|[.]md$|[.]rc$|[.]json$|[.]sh$|[.]git$|[.]conf$|[.]py$|[.]rasi$|[.]mk$|[.]h$|[.]desktop$|[.]AppImage$|[.]crt$|[.]bash$|[.]config$|[.]log$|[.]tmp$|[.]ini$|[.]old$|[.]code$|[.]backup$|[.]vscdb$|[.]haskell$|[.]c$|[.]cnf$|[.]hs$|[.]groff$|[.]java$|[.]dat$|[.]js$|[.]gif$|[.]html$|json~$|[.]bak$|[.]ico$|[.]svg$|[.]yml$|[.]cache$|[.]po$|[.]Po$|[.]ac$|[.]m$|[.]install$|[.]x$|[.]y$|[.]cabal$|[.]mdown$|[.]markdown$|[.]micro$|[.]toml$|[.]orig$|[.]yaml$|[.]README$|[.]bat$|[.]cpp$|[.]pl$|[.]app$|[.]icns$|[.]man$|[.]fish$|[.]rtf$|[.]cc$|[.]d$|[.]vscode$|[.]ghc$|[.]sys$|[.]ssh$|[.]pub$|[.]xinitrc$|[.]srt$|[.]kdenlive$|[.]aac$|[.]vtt$|[.]wav$|[.]ma$|[.]mkv$|[.]mozilla$|[.]dmp$|[.]co$|[.]ghcup$|[.]nanorc$|[.]pki$|[.]themes$|[.]gpg$|[.]tar$|[.]gitconfig$|[.]profile$|[.]s$|[.]dmrc$|[.]nano$|[.]bashrc$|[.]lesshst$|[.]xpm$|[.]xbm$|[.]styles$|[.]layout$|[.]menu$|[.]doc$|[.]htm$|[.]ogg$|[.]bmp$|[.]ods$|[.]out$|[.]ms$|[.]cfg$|[.]lua$|[.]go$|[.]gpx$|[.]lang$|[.]m4v$" >> ~/Programs/output/updated/files.txt

# Remove certain folders which have large numbers of files 
sed -i "/~\/\.config\/Code - OSS/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/discord\/0\.0\.25\/modules/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/google-chrome\/Default\/Extensions/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/opera\/Extensions/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Downloads\/BackupDec/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Programs\/configure\/home/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Programs\/output\/updated\/filesFinal.txt/d" ~/Programs/output/updated/files.txt
#sed -i "/~\/Programs\/organisation/d" ~/Programs/output/updated/files.txt
# Remove curPlaylist so there aren't duplicate songs. Super+L can be used to play music from curPlaylist 
sed -i "/~\/Music\/curPlaylist/d" ~/Programs/output/updated/files.txt

# Add back the settings.json file for VSCode 
echo "$HOME/.config/Code - OSS/User/settings.json" >> ~/Programs/output/updated/files.txt

# Add shebang to filesIcons.sh
echo "#!/usr/bin/env bash" > ~/Programs/output/updated/filesIcons.sh

# Add necessary echo commands to filesIcons.sh and make executable 
~/Programs/system/rofi/addIcons.sh >> ~/Programs/output/updated/filesIcons.sh
chmod +x ~/Programs/output/updated/filesIcons.sh

# Run script 
~/Programs/output/updated/filesIcons.sh >> ~/Programs/output/updated/filesFinal.txt

#cp ~/Programs/output/updated/files.txt ~/Programs/output/updated/filesTest.txt

# Move filesFinal.txt to files.txt
mv ~/Programs/output/updated/filesFinal.txt ~/Programs/output/updated/files.txt
