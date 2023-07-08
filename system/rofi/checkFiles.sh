#!/usr/bin/env bash

#SAVEIFS=$IFS # Save current IFS (Internal Field Separator)
#IFS=$'\n'

#listOfFiles+=($(find ~/Documents))
#listOfFiles+=($(find ~/Downloads))
#listOfFiles+=($(find ~/Pictures))
#listOfFiles+=($(find ~/Videos))
#listOfFiles+=($(find ~/Music))
#listOfFiles+=($(find ~/Programs))
#listOfFiles+=($(find ~/.config))
#listOfFiles+=($(find ~ -maxdepth 1))

#for i in ${!listOfFiles[@]}; do # Tag
#	echo $i "${listOfFiles[$i]}"
#done

#IFS=$SAVEIFS

IFS=$'\n'

#programs=( $(cat ~/Programs/output/updated/programs.txt) )

#if (( ${#programs[@]} == 0 )); then
#	exit
#fi

rm ~/Programs/output/updated/files.txt

#for x in "${programs[@]}"; do
#	first=$(echo "$x" | cut -d\; -f1)
#	echo "$first" >> ~/Programs/output/updated/files.txt
#done

~/Programs/output/updated/programsIcons.sh > ~/Programs/output/updated/filesFinal.txt

find ~/Documents ~/Downloads ~/Music ~/Pictures ~/Videos ~/Desktop ~/Programs ~/.config -mindepth 1 -type f | sed 's|'"${HOME}"'|~|g' | grep -P "[.]csv$|[.]txt$|mp3$|[.]m4a$|mp4$|[.]webm$|[.]mov$|[.]avi$|[.]png$|[.]webp$|[.]jpg$|[.]jpeg$|[.]inputrc$|[.]xml$|[.]css$|[.]md$|[.]rc$|[.]json$|[.]sh$|[.]git$|[.]conf$|[.]py$|[.]rasi$|[.]mk$|[.]h$|[.]desktop$|[.]AppImage$|[.]crt$|[.]bash$|[.]config$|[.]log$|[.]tmp$|[.]ini$|[.]old$|[.]code$|[.]backup$|[.]vscdb$|[.]haskell$|[.]c$|[.]cnf$|[.]hs$|[.]groff$|[.]java$|[.]dat$|[.]js$|[.]gif$|[.]html$|json~$|[.]bak$|[.]ico$|[.]svg$|[.]yml$|[.]cache$|[.]po$|[.]ac$|[.]m$|[.]install$|[.]x$|[.]y$|[.]cabal$|[.]mdown$|[.]markdown$|[.]micro$|[.]toml$|[.]orig$|[.]yaml$|[.]README$|[.]bat$|[.]cpp$|[.]pl$|[.]app$|[.]icns$|[.]man$|[.]fish$|[.]rtf$|[.]cc$|[.]d$|[.]vscode$|[.]ghc$|[.]sys$|[.]ssh$|[.]pub$|[.]xinitrc$|[.]srt$|[.]kdenlive$|[.]aac$|[.]vtt$|[.]wav$|[.]ma$|[.]mkv$|[.]mozilla$|[.]dmp$|[.]co$|[.]ghcup$|[.]nanorc$|[.]pki$|[.]themes$|[.]gpg$|[.]tar$|[.]gitconfig$|[.]profile$|[.]s$|[.]dmrc$|[.]nano$|[.]bashrc$|[.]lesshst$|[.]xpm$|[.]xbm$|[.]styles$|[.]layout$|[.]menu$|[.]doc$|[.]htm$|[.]ogg$|[.]bmp$|[.]ods$|[.]out$|[.]ms$|[.]cfg$|[.]lua$|[.]go$|[.]gpx$" >> ~/Programs/output/updated/files.txt
find ~ -maxdepth 1 -type f | sed 's|'"${HOME}"'|~|g' | grep -P "[.]csv$|[.]txt$|mp3$|[.]m4a$|mp4$|[.]webm$|[.]mov$|[.]avi$|[.]png$|[.]webp$|[.]jpg$|[.]jpeg$|[.]inputrc$|[.]xml$|[.]css$|[.]md$|[.]rc$|[.]json$|[.]sh$|[.]git$|[.]conf$|[.]py$|[.]rasi$|[.]mk$|[.]h$|[.]desktop$|[.]AppImage$|[.]crt$|[.]bash$|[.]config$|[.]log$|[.]tmp$|[.]ini$|[.]old$|[.]code$|[.]backup$|[.]vscdb$|[.]haskell$|[.]c$|[.]cnf$|[.]hs$|[.]groff$|[.]java$|[.]dat$|[.]js$|[.]gif$|[.]html$|json~$|[.]bak$|[.]ico$|[.]svg$|[.]yml$|[.]cache$|[.]po$|[.]ac$|[.]m$|[.]install$|[.]x$|[.]y$|[.]cabal$|[.]mdown$|[.]markdown$|[.]micro$|[.]toml$|[.]orig$|[.]yaml$|[.]README$|[.]bat$|[.]cpp$|[.]pl$|[.]app$|[.]icns$|[.]man$|[.]fish$|[.]rtf$|[.]cc$|[.]d$|[.]vscode$|[.]ghc$|[.]sys$|[.]ssh$|[.]pub$|[.]xinitrc$|[.]srt$|[.]kdenlive$|[.]aac$|[.]vtt$|[.]wav$|[.]ma$|[.]mkv$|[.]mozilla$|[.]dmp$|[.]co$|[.]ghcup$|[.]nanorc$|[.]pki$|[.]themes$|[.]gpg$|[.]tar$|[.]gitconfig$|[.]profile$|[.]s$|[.]dmrc$|[.]nano$|[.]bashrc$|[.]lesshst$|[.]xpm$|[.]xbm$|[.]styles$|[.]layout$|[.]menu$|[.]doc$|[.]htm$|[.]ogg$|[.]bmp$|[.]ods$|[.]out$|[.]ms$|[.]cfg$|[.]lua$|[.]go$|[.]gpx$" >> ~/Programs/output/updated/files.txt

sed -i "/~\/\.config\/Code - OSS/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/discord\/0\.0\.25\/modules/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/google-chrome\/Default\/Extensions/d" ~/Programs/output/updated/files.txt
sed -i "/~\/\.config\/opera\/Extensions/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Downloads\/BackupDec/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Programs\/configure\/home/d" ~/Programs/output/updated/files.txt
#sed -i "/~\/Programs\/organisation/d" ~/Programs/output/updated/files.txt
sed -i "/~\/Music\/curPlaylist/d" ~/Programs/output/updated/files.txt

echo "$HOME/.config/Code - OSS/User/settings.json" >> ~/Programs/output/updated/files.txt

echo "#!/usr/bin/env bash" > ~/Programs/output/updated/filesIcons.sh

~/Programs/system/rofi/addIcons.sh >> ~/Programs/output/updated/filesIcons.sh

chmod +x ~/Programs/output/updated/filesIcons.sh

~/Programs/output/updated/filesIcons.sh >> ~/Programs/output/updated/filesFinal.txt

cp ~/Programs/output/updated/files.txt ~/Programs/output/updated/filesTest.txt

mv ~/Programs/output/updated/filesFinal.txt ~/Programs/output/updated/files.txt
