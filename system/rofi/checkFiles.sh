#!/usr/bin/env bash

# Script to index files for rofiLauncher.sh

#SAVEIFS=$IFS # Save current IFS (Internal Field Separator)
#IFS=$'\n'

#for i in ${!listOfFiles[@]}; do # Tag
#	echo $i "${listOfFiles[$i]}"
#done

#IFS=$SAVEIFS

IFS=$'\n'

#for x in "${programs[@]}"; do
#	first=$(echo "$x" | cut -d\; -f1)
#	echo "$first" >> ~/Programs/output/updated/files2.txt
#done

# Add programs (with icons) first so they will be at the start 
~/Programs/output/updated/programsIcons.sh > ~/Programs/output/updated/filesFinal.txt

# Add shebang to filesIcons.sh
echo "#!/usr/bin/env bash" > ~/Programs/output/updated/filesIcons.sh

# Add in TV Shows from ~/Videos/Media
ls ~/Videos/Media | tr -d "/" | sed -n 's/\(.*\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/apps\/tvtime.svg\\n\"/p' >> ~/Programs/output/updated/filesIcons.sh

# Find files in main folders and .config 
find ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos ~/Desktop ~/Programs ~/.config ~/Work -mount -mindepth 1 -type f | sed 's|'"${HOME}"'|~|g' | grep -P "[.]csv$|[.]txt$|mp3$|[.]m4a$|mp4$|[.]webm$|[.]mov$|[.]avi$|[.]png$|[.]webp$|[.]jpg$|[.]jpeg$|[.]inputrc$|[.]xml$|[.]css$|[.]md$|[.]rc$|[.]json$|[.]sh$|[.]git$|[.]conf$|[.]py$|[.]rasi$|[.]mk$|[.]h$|[.]desktop$|[.]AppImage$|[.]crt$|[.]bash$|[.]config$|[.]log$|[.]tmp$|[.]ini$|[.]old$|[.]code$|[.]backup$|[.]vscdb$|[.]haskell$|[.]c$|[.]cnf$|[.]hs$|[.]groff$|[.]java$|[.]dat$|[.]js$|[.]gif$|[.]html$|json~$|[.]bak$|[.]ico$|[.]svg$|[.]yml$|[.]cache$|[.]po$|[.]Po$|[.]ac$|[.]m$|[.]install$|[.]x$|[.]y$|[.]cabal$|[.]mdown$|[.]markdown$|[.]micro$|[.]toml$|[.]orig$|[.]yaml$|[.]README$|[.]bat$|[.]cpp$|[.]pl$|[.]app$|[.]icns$|[.]man$|[.]fish$|[.]rtf$|[.]cc$|[.]d$|[.]vscode$|[.]ghc$|[.]sys$|[.]ssh$|[.]pub$|[.]xinitrc$|[.]srt$|[.]kdenlive$|[.]aac$|[.]vtt$|[.]wav$|[.]ma$|[.]mkv$|[.]mozilla$|[.]dmp$|[.]co$|[.]ghcup$|[.]nanorc$|[.]pki$|[.]themes$|[.]gpg$|[.]tar$|[.]gitconfig$|[.]profile$|[.]s$|[.]dmrc$|[.]nano$|[.]bashrc$|[.]lesshst$|[.]xpm$|[.]xbm$|[.]styles$|[.]layout$|[.]menu$|[.]doc$|[.]htm$|[.]ogg$|[.]bmp$|[.]ods$|[.]out$|[.]ms$|[.]cfg$|[.]lua$|[.]go$|[.]gpx$|[.]lang$|[.]m4v$|[.]pdf$|[.]rs$|[.]sql$" >> ~/Programs/output/updated/files2.txt
# Find files in home directory without going into folders
find ~ -mount -maxdepth 1 -type f | sed 's|'"${HOME}"'|~|g' >> ~/Programs/output/updated/files2.txt

# Remove certain folders which have large numbers of files 
sed -i "/~\/\.config\/Code/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/\.config\/chromium\/Default/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/\.config\/discord\/0\.0\.25\/modules/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/\.config\/google-chrome/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/\.config\/opera\/Extensions/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Downloads\/BackupDec/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Downloads\/otherPrograms/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/configure\/home/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Videos\/Media/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/output\/updated\/filesFinal.txt/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Downloads\/emojis/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Downloads\/VSCode-linux-x64/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/.venv/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/output\/.covers/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/newPrograms\/other\/200018109-CS3104-P1\/Tests/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/archive\/privateCodeArchive\/minecraftItemSorting/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/archive\/privateCodeArchive\/gotubeTestingStuff/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/archive\/privateCodeArchive\/items/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/myRepos\/totalsizeContinued\/totalsize\/yt_dlp/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/myRepos\/GoTube-YouTube-Client\/yt-dlp/d" ~/Programs/output/updated/files2.txt
sed -i "/~\/Programs\/forkedRepos\/trash-cli\/env\/lib/d" ~/Programs/output/updated/files2.txt
#sed -i "/~\/Programs\/organisation/d" ~/Programs/output/updated/files2.txt
# Remove curPlaylist so there aren't duplicate songs. Super+L can be used to play music from curPlaylist 
sed -i "/~\/Music\/curPlaylist/d" ~/Programs/output/updated/files2.txt

# Add back the settings.json file for VSCode 
echo "$HOME/.config/Code - OSS/User/settings.json" >> ~/Programs/output/updated/files2.txt

# Add necessary echo commands to filesIcons.sh and make executable 
~/Programs/system/rofi/addIcons.sh | sed 's/`/\\`/g' >> ~/Programs/output/updated/filesIcons.sh
chmod +x ~/Programs/output/updated/filesIcons.sh

# Run script 
~/Programs/output/updated/filesIcons.sh >> ~/Programs/output/updated/filesFinal.txt
# NEW WAY WITH GO SCRIPT
#~/Programs/system/rofi/addIcons >> ~/Programs/output/updated/filesFinal.txt


#cp ~/Programs/output/updated/files2.txt ~/Programs/output/updated/filesTest.txt
cp ~/Programs/output/updated/files2.txt ~/Programs/output/updated/test.txt
rm ~/Programs/output/updated/files2.txt
# Move filesFinal.txt to files.txt
rm ~/Programs/output/updated/files.txt
mv ~/Programs/output/updated/filesFinal.txt ~/Programs/output/updated/files.txt
