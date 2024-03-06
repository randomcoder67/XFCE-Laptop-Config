# System Usage 

## Terminal Aliases

### Program openers

`m` open file in mousepad (fasd)  
`ms` opens file(s) in mousepad (normal)  
`mn` open file in new window in mousepad (fasd)  
`msn` opens file(s) in new window in mousepad (normal)  
`lt` opens file(s)/folder in Lite-Xl  
`r` opens image in Ristretto (fasd)  
`rs` opens image(s) in Ristretto (normal)  
`p` opens video/audio file (fasd)  
`mpv` opens video/audio files (normal)  
`mpv-yt` play YouTube videos/playlists in mpv  
`mpvr` play all videos in folder in reverse  
`pdf` opens pdf in zathura  

### System management 

`shutdown` shutdown now (with confirmation)  
`reboot` reboot (with confirmation)  
`hibernate` hibernate (with confirmation)  
`hybrid-sleep` sleep (hybrid-sleep, to RAM or to disk if battery dies, with confirmation)  
`log-out` log out (with confirmation)  
`qsleep` sleep (normal sleep, to RAM only, faster)  

### Unix terminal programs

`hs` shows command history  
`his` searches command history  
`c` clear  
`cl` clear and ls  
`x` make file executable  
`grep` grep (ignore case)  
`greps` grep (case sensitive)  
`grepa` grep (print surrounding lines)  
`grepc` grep (print surrounding characters)  
`l` lists files/dirs in directory (one per line)  
`ls` lists files/dirs in directory  
`lsa` lists files/dirs in directory (including hidden)  
`la` lists files/dirs in directory (one per line, including hidden)  
`lsl` list files/dirs in directory (detail)  
`lsal` list files/dirs in directory (including hidden, detail)  
`lsf` list files in directory (recursive)  
`lsaf` list files in directory (including hidden, recursive)  
`ld` list only directories (one per line)  
`lda` list only directories (one per line, including hidden)  
`lsd` list only directories  
`lsdl` list only directories (detail)  
`lsda` list only directories (including hidden)  
`lsdal` list only directories (including hidden, detail)  
`mv` moves file (asks for confirmation if overwriting)  
`cp` copies file (asks for confirmation if overwriting)  
`diff` checks for differences in files  
`wget` wget with history file set to XDG cache directory  
`mkcdir` make directory and cd into it  
`cal` shows next 3 months (inclusive)  
`as` made as an alias to stop accidental creation of a.out file  
`lsblk` lsblk with filesystem type  

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
`bac` cd into backup folder  
`con` cd into ~/.config  
`loc` cd into ~/.local/share  
`doc` cd into ~/Documents  
`dow` cd into ~/Downloads  
`pic` cd into ~/Pictures  
`vid` cd into ~/Videos  
`mus` cd into ~/Music  
`pro` cd into ~/Programs  
`cur` cd into ~/Music/curPlaylist  
`wor` cd into ~/Work  
`bin` cd into ~/.local/bin  
`web` cd into ~/Programs/website  

### Shortcuts

#### PacMan 

`install` install package with pacman  
`remove` remove package with pacman  
`update` update and upgrade system with pacman  
`search` search pacman for packages  
`list` list manually installed pacman packages  
`pacs` get number of installed packages  

#### yt-dlp 

`yt-dlp` yt-dlp without the video ID in filename  
`yt-aria` yt-dlp using aria2c as downloader  
`yt-aria-limit` yt-dlp using aria2c as downloader (limited to 3MB/s)  
`yt-folder` yt-dlp from an input file (-l to use download limit)  
`yt-music` download music in format required for music-tag program  
`yt-playlist` download playlist, includes cookies from firefox, embed chapters and thumbnail, and 22 quality setting  
`yt-playlist-limit` download playlist (limited to 3MB/s)  

#### Web Alternatives

`wl` select video from YouTube Watch Later to play with mpv  
`ytlen` get length of YouTube playlist  
`ythis` save YouTube history to  

#### Git

`gp` git pull  
`gits` git status  
`gitd` git diff  
`gitl` git log  
`gitpass` get GitHub key from pass  
`giturl` get url of current Git repository  

#### Other 

`nf` neofetch  
`py` python3  
`sq` ncdu to check files sizes  
`bat` view files in terminal  
`batl` view last file (alphabetical) in directory  
`q` trims bash history and exits  
`reload` reloads bashrc  
`ghc` ghc with dynamic flag (necessary for Arch Linux)  
`balance` balance audio with aacgain  
`clearlogs` clear journalctl of logs older than 2 days  
`hashfolder` gets checksum hash for all files in given folder (sha256sum)  
`cmpfolder` cmp files in two directories  
`music` play music (defaults to curPlaylist, use `-a artist` to play music by given artist)  
`tagmusic` run music tag program (Usage: `tagmusic filename.m4a AppleMusicAlbumID`)  
`files` get number of files and programs in rofiLauncher.sh  
`vol` get current volume  
`mtmv` perl-rename  
`savedotfiles` copy current dotfiles to ~/Programs/configure  
`songs` show file of songs identified with songrec  
`todo` open todo.md file  
`emails` open emails.md file  
`lc` count items in folder  
`lca` count items in folder (include hidden)  
`lcd` count directories in folder  
`lcda` count directories in folder (including hidden)  
`rmedir` remove empty dirs  
`gtop` Intel GPU Top (needs sudo)  
`remake` Recompile all of my programs/scripts  
`bookmarks` get number of bookmarks  
`lcr` count items in folder (recursive)  
`lcra` count items in folder (recursive and include hidden)  
`anonprompt` swap prompt for one without username or hostname  
`serial` get serial number  
`pyweb` start simple http server with root as given directory  
`cmatrix` cmatrix with speed of 6  

### Info programs

`schedule` schedule program  
`log` log program  
`dreams` dream entry into log program  
`weather` weather  
`t` display time in various timezones  
`shows` list show times in the week  
`money` money program  
`days` shows time until specific days  

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
`sky` get position of planets in sky  
`timer` timer program  
`domount` disk mounting script  
`ipodsync` sync iPod Shuffle 4th gen with CurrentPlaylist folder  
`render` markdown to html  
`mt` metric time  
`downloadt` download time calculator  

### Fun

`asq` ascii aquarium  
`stonehenge` ascii stonehenge  

## Keyboard shortcuts 

### Xfce general 

`Super` Launcher  
`Super+F` Search files (~)  
`Super+Q` Bookmarks (`ctrl+a` to add, `ctrl+w` to remove, `shift+enter` to type selected item)  
`Super+V` Rofi system usage information  
`Super+Return` Alacritty  
`Super+Shift+Return` Xfce4 Terminal  
`Super+W` Firefox  
`Super+S` GoTube  
`Super+E` Thunar File Manager  
`Super+M` Mousepad  
`Super+Shift+M` Mousepad (New Window)  
`Super+R` Identify Song  
`Super+L` Play music from `~/Music/curPlaylist`  
`Super+Shift+L` Play music from `~/Music/curPlaylist` in background  
`Super+O` Choose playlist to play music from  
`Super+Shift+O` Choose playlist to play music from in background  
`Super+C` Calculator  
`Super+H` htop  
`Super+B` btop  
`Super+N` NetHogs  
`Super+G` pulsemixer  
`Super+U` cava visualiser  
`Super+Y` colour pick, copies to clipboard  
`Super+Backtick` Screenshot Utility  
`Super+P` Plugging/Unplugging from Monitor  
`Super+K` Expand Left Window in Horizontal Split  
`Super+J` Expand Right Window in Horizontal Split  
`Ctrl+Alt+Del` Logout  
`Super+]` Increase Volume 3%  
`Super+[` Decrease Volume 3%  
`Super+X` System Menu  
`Super+I` Link Markdown Files  
`Super+Shift+[` Play/Pause Music  
`Super+Shift+]` Display Currently Playing Song  
`Super+-` Skip To Previous Track  
`Super+=` Skip To Next Track  
`Super+Shift+=` Add Currently Playing Song To Favourites  
`Super+Shift+-` Close Currently Playing Music  
`Super+Shift+C` Clear All Notifications  

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
`Super+Ctrl+#` Move window to upper monitor  
`Super+Ctrl+'` Move window to lower monitor  
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

### Special Characters

`Super+1` Special character 1  
`Super+2` Special character 2  
`Super+3` Special character 3  
`Super+4` Special character 4  
`Super+5` Special character 5  
`Super+6` Special character 6  
`Super+7` Special character 7  
`Super+8` Special character 8  
`Super+9` Special character 9  
`Super+0` Special character 0  

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
`Enter` Playlist Next  
`Shift+Enter` Playlist Previous  

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
`?` Toggle OSC  
`m` Toggle Mute  
`Shift+m` Show Metadata  
`Shift+k` Lock window size  
`Shift+v` Toggle Mono Audio  

### Rofi Bookmarks 

`Ctrl+A` to add  
`Ctrl+W` to remove  
`Return` to copy  
`Shift+Return` to open in Firefox  

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
