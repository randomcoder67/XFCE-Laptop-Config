# System Usage 

## Terminal Aliases

### Program openers

`ms` opens file(s) in mousepad  
`msn` opens file(s) in new window in mousepad  
`rs` opens image(s) in Ristretto  
`mpv` opens video/audio files  
`pdf` opens pdf in zathura  

### System management 

`shutdown` shutdown now (with confirmation)  
`reboot` reboot (with confirmation)  
`hibernate` hibernate (with confirmation)  
`snooze` sleep (hybrid-sleep, to RAM or to disk if battery dies, with confirmation)  

### Unix terminal programs

`gp` git pull  
`his` searches history  
`c` clear  
`cl` clear and ls  
`x` make file executable  
`grep` grep (ignore case)  
`grepa` grep (ignore case and print surrounding lines)  
`l` lists files in directory  
`ls` lists files in directory  
`lsa` lists files in directory (including hidden files)  
`mv` moves file (asks for confirmation if overwriting)  
`cp` copies file (asks for confirmation if overwriting)  
`diff` checks for differences in files  
`wget` wget with history file set to XDG cache directory  
`mkcdir` make directory and cd into it  

### Stream things

`destiny` plays Destiny stream  
`chudlogic` plays Chud Logic stream  
`nerdcubed` plays NerdCubed stream  
`matn` plays MATN stream  
`dustineden` plays Dustin Eden stream  
`dgg` opens dgg chat  
`streams` checks streams and outputs live status  
`wstream` downloads Destiny livestreams  

### cd Shortcuts

`steamapps` cd into steamapps folder  
`papirus` cd into papirus icons folder  
`cdb` cd into backup folder  
`con` cd into ~/.config  
`loc` cd into ~/.local/share  
`doc` cd into ~/Documents  
`dow` cd into ~/Downloads  
`pic` cd into ~/Pictures  
`vid` cd into ~/Videos  
`mus` cd into ~/Music  
`pro` cd into ~/Programs  
`cur` cd into ~/Music/curPlaylist  

### Shortcuts

`nf` neofetch  
`py` python3  
`sq` ncdu to check files sizes  
`bat` view files in terminal
`q` trims bash history and exits  
`install` install package with pacman  
`remove` remove package with pacman  
`update` update and upgrade system with pacman  
`search` search pacman for packages
`reload` reloads bashrc  
`ghc` ghc with dynamic flag (necessary for Arch Linux)  
`balance` balance audio with aacgain  
`clearlogs` clear journalctl of logs older than 2 days  
`yt-dlp` yt-dlp without the video ID in filename  
`yt-aria` yt-dlp using aria2c as downloader  
`yt-aria-limit` yt-dlp using aria2c as downloader (limited to 3MB/s)  
`yt-folder` yt-dlp from an input file (-l to use download limit)  
`yt-music` download music in format required for music-tag program  
`hashfolder` gets checksum hash for all files in given folder (sha256sum)  
`cmpfolder` cmp files in two directories  
`music` play music (defaults to curPlaylist, use `-a artist` to play music by given artist)  
`tagmusic` run music tag program (Usage: `tagmusic filename.m4a AppleMusicAlbumID`)  
`gits` git status  
`gitd` git diff  
`gitl` git log  
`gitpass` get GitHub key from pass  
`pacs` get number of installed packages  
`files` get number of files and programs in rofiLauncher.sh  
`mtmv` perl-rename  
`savedotfiles` copy current dotfiles to ~/Programs/configure  
`cmpbackup` compare last 2 backup hashes  

### Info programs

`fitness` fitness program  
`schedule` schedule program  
`log` log program  
`weather` weather  
`t` display time in various timezones  
`shows` list show times in the week  

### File finders 

`findh` searches home directory for file  
`findr` searches root directory for file  
`glowf` finds and displays files with glow  
`batf` finds and displays files with bat  
`mpvf` finds and opens video/audio files  

### My terminal programs

`albumart` display collage of album art from current playlist  
`groffdoc` convert markdown to PDF with groff  
`programs` add or remove programs from Rofi Launcher  
`checkfiles` updates list of files for Rofi Launcher  
`rm` delete files or directories, moves to recycle bin  
`backup` backup program  
`stuff` query and edit list of owned stuff  
`strava` run strava program  
`setlocation` change current location  
`getpass` get randomly generated password  
`sky` get position of planets in sky  

### Fun

`asq` ascii aquarium  

## Keyboard shortcuts 

### Xfce general 

`Super` Launcher  
`Super+F` Search files (~)  
`Super+V` Bookmarks (`ctrl+a` to add, `ctrl+w` to remove, `shift+enter` to type selected item)  
`Super+Q` Rofi system usage information  
`Super+Return` Alacritty  
`Super+Shift+Return` Xfce4 Terminal  
`Super+W` Firefox  
`Super+E` Thunar File Manager  
`Super+M` Mousepad  
`Super+R` Identify Song  
`Super+L` Play music from `~/Music/curPlaylist`  
`Super+C` Calculator  
`Super+H` htop  
`Super+B` btop  
`Super+G` pulsemixer  
`Super+Backtick` Screenshot Utility  
`Super+S` Settings Manager  
`Super+P` Plugging/Unplugging from Monitor  
`Super+K` Expand Left Window in Horizontal Split  
`Super+J` Expand Right Window in Horizontal Split  
`Ctrl+Alt+Del` Logout  

### Xfwm 

`Alt+Tab` Cycle windows  
`Alt+Backtick` Cycle windows of the same application  
`Super+D` Show desktop/Restore programs  
`Super+Shift_R` Maximise/Restore window  
`Super+Ctrl+Shift_R` Minimise window  
`Super+Shift+Q` Close window/logout  
`Super+Shift+R` Resize window  
`Super+Shift+X` Stick window  
`Super+Shift+F` Keep window on top  
`Super+.` Next workspace  
`Super+,` Previous workspace  
`Super+Ctrl+.` Move window to next workspace  
`Super+Ctrl+,` Move window to previous workspace  
`Super+Alt+.` Add new workspace  
`Super+Alt+,` Remove last workspace  
`Super+Left` Snap window to left  
`Super+Right` Snap window to right  
`Super+Up` Snap window to top  
`Super+Down` Snap window to bottom  
`Super+Fn+Left` Snap window to bottom left  
`Super+Fn+Right` Snap window to top right  
`Super+Fn+Up` Snap window to top left  
`Super+Fn+Down` Snap window to bottom right  

## Programs 

### mpv 

#### Skipping 

`Right` Skip 5s  
`Left` Rewind 5s  
`Up` Skip 30s  
`Down` Rewind 30s  

#### Navigation 

`Shift+Right` Next Chapter  
`Shift+Left` Previous Chapter  
`Shift+N` Playlist Next  
`Shift+P` Playlist Previous  

#### Speed 

`d` Speed +0.1x  
`s` Speed -0.1x  
`r` Speed 1x  
`g` Speed 2x Toggle  
`x` Show Current Speed  

#### Other 

`Shift+S` Screenshot (`~/Pictures/mpv/`)  
`c` List Chapters  
`u` Show Playlist  
`/` Show OSC  

### Rofi Bookmarks 

`Ctrl+A` to add  
`Ctrl+W` to remove  
`Return` to copy  
`Shift+Return` to type  

### Rofi Launcher 

`Return` to open  
`Shift+Return` to choose application to open with (only for files)  

### Mousepad 

`Ctrl+K` delete line  
`Ctrl+D` duplicate line  
`Ctrl+Tab` next tab  
`Ctrl+Shift+Tab` previous tab  
`Ctrl+Shift+T` strip trailing spaces  
`Ctrl+Shift+K` toggle spellcheck  
`Ctrl+Shift+D` detach tab  
`Ctrl+N` new tab  
`Ctrl+W` close tab  
`Ctrl+Q` exit  
`Ctrl+M` toggle toolbar  
`Ctrl+I` indent line  
`Ctrl+U` unindent line  

### Micro 

`Ctrl+K` delete line  
`Ctrl+D` duplicate line  
`Ctrl+S` next tab  
`Ctrl+N` new tab  
`Ctrl+W` close tab  
`Ctrl+Q` exit  
`Ctrl+O` indent line  
`Ctrl+U` unindent line  
