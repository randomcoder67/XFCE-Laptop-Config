#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
	source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

# Load bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
  fi
fi

# Normal prompt
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# Prompt without username 
#PS1='\[\033[1;36m\]user\[\033[1;31m\]@\[\033[1;32m\]laptop:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# Prompt with time 
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\033[1;33m\][\t]\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# Functions

# Make directory and cd into it
mkcdir () {
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

# Grep but only show surrounding character, useful for files with very long lines, like a lot of HTML files
grepc () {
	grep --color=no -i -I -o -P ".{0,100}$1.{0,100}" $2
}

# Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	[[ "$yesOrNoShutdown" == "y" ]] && xfce4-session-logout -h
}

# Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	[[ "$yesOrNoReboot" == "y" ]] && xfce4-session-logout -r
}

# Hibernate to disk with confirmation
hibernate () {
	read -p "Hibernate? (y/N) " yesOrNoHibernate
	[[ "$yesOrNoHibernate" == "y" ]] && xfce4-session-logout -i
}

# Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read -p "Hybrid-Sleep? (y/N) " yesOrNoHybridSleep
	[[ "$yesOrNoHybridSleep" == "y" ]] && xfce4-session-logout -b
}

# Sleep with confirmation (i.e. RAM only)
qsleep () {
	read -p "Sleep? (y/N) " yesOrNoQSleep
	[[ "$yesOrNoQSleep" == "y" ]] && xfce4-session-logout -s
}

# Log Out with confirmation
log-out () {
	read -p "Log Out? (y/N) " yesOrNoLogOut
	[[ "$yesOrNoLogOut" == "y" ]] && xfce4-session-logout -l
}

# Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && xfce4-screensaver-command -l
}

# Open pdf files in Zathura
pdf () {
	for arg; do
		zathura "$arg" & disown
	done
}

# Open folder/files in Lite-XL
lt () {
	lite-xl "$@" & disown
}

# Open file with Mousepad (fasd)
_m () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	mousepad "$result" & disown
}

# Open files with Mousepad (normal)
ms () {
	for arg; do
		mousepad "$arg" & disown
	done
}

# Open file with Mousepad in a new window (fasd)
mn () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	mousepad -o window "$result" & disown
}

# Open files with Mousepad in a new window (normal)
msn () {
	mousepad -o window & disown
	sleep 0.2
	for arg; do
		mousepad "$arg" & disown
	done
}

# Open video with mpv (fasd)
_p () {
	#result=$(fasd -s $@ | grep -E 'mp3|m4a|ogg|wav|webm|mp4|m4v|mkv|avi|mov' | tr -s ' ' | cut -d " " -f 2- | tail -n 1)
	result=$(fasd -fi $@)
	/usr/bin/mpv --really-quiet --save-position-on-quit "$result" & disown
}

# Open video(s) with mpv (normal)
do_mpv () {
	/usr/bin/mpv --really-quiet --save-position-on-quit "$@" & disown
}

# Open YouTube video with mpv
do_mpv-yt () {
	/usr/bin/mpv --really-quiet --title='${media-title}' --ytdl-format=best "$@" & disown
}

# Open images in Ristretto (fasd)
_r () {
	#result=$(fasd -s $@ | grep -E 'png|svg|jpg|jpeg|gif|bmp' | tr -s ' ' | cut -d " " -f 2- | tail -n 1)
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	ristretto "$result" & disown
}

# Open images in Ristretto (normal)
rs () {
	toOpen=$@
	if [[ "$toOpen" == "" ]]; then
		ristretto . & disown
	else
		ristretto "$@" & disown
	fi
}

# Move image and tags with tmsu
tmsumv () {
	mv "$1" "$2" && tmsu repair --manual "$1" "$2"
}

# Open images with given tmsu tag in Ristretto
view () {
	tmsu files "$1" | grep -P ".jpg|.jpeg|.png|.webp" | xargs ristretto & disown
}

# Search root directory
findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

# Launch ChudLogic stream
do_chudlogic () {
	/usr/bin/mpv --really-quiet --ytdl-format=best --title="Chud Logic" https://www.youtube.com/@ChudLogic/live || notify-send "Error, YouTube stream failed to open" 2>&1 & disown
	#/usr/bin/mpv --really-quiet --title="Chud Logic" https://www.twitch.tv/chudlogic best || notify-send "Error, Twitch stream failed to open" 2>&1 & disown
}

# Function to show time in various locations
t () {
	metricTimeDays=$(~/Programs/terminal/terminalPrograms/goBins/metricTime -d -s)
	metricTimeMinutes=$(~/Programs/terminal/terminalPrograms/goBins/metricTime -m -s)
	metricTimeSeconds=$(~/Programs/terminal/terminalPrograms/goBins/metricTime -s -s)
	curDateZone=$(date +"%a, %b %d (%Z)")
	echo -e "\033[0;35m\033[1mMetric Time\033[0m:"
	echo "  Days:           $metricTimeDays - $curDateZone"
	echo "  Minutes:        $metricTimeMinutes - $curDateZone"
	echo "  Seconds:        $metricTimeSeconds - $curDateZone"
	echo -e "\033[0;35m\033[1mNormal Time\033[0m:"
	TZ="America/Los_Angeles" date +"  Los Angeles:    %H:%M:%S - %a, %b %d (%Z)"
	TZ="America/New_York" date +"  New York:       %H:%M:%S - %a, %b %d (%Z)"
	date -u +"  UTC:            %H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/London" date +"  London:         %H:%M:%S - %a, %b %d (%Z)"
	TZ="Asia/Seoul" date +"  Seoul:          %H:%M:%S - %a, %b %d (%Z)"
	TZ="Australia/Sydney" date +"  Sydney:         %H:%M:%S - %a, %b %d (%Z)"
}	

# Function to remove things which aen't useful from bash history
trim_history () {
	# Remove literal "q", "ls", "l", "lsa", "exit", "c", "cl", "cd", "rm", "x", "gits", "gitd", "gitl", "htop", "btop", "nethogs", "cava", "vis", "qalc", "history" and "hs" from bash history
	sed -i -r '/^(history|hs|qalc|vis|cava|nethogs|btop|htop|gitl|gitd|gits|x|rm|cd|c|exit|lsa|ls|l|q)$/d' ~/.bash_history
	# Remove any usage of fasd z autojump command
	sed -i '/^z .*/d' ~/.bash_history
	sed -i '/^zz .*/d' ~/.bash_history
	# Remove any usage of rm command
	sed -i '/^rm .*/d' ~/.bash_history
	sed -i '/^youtube .*/d' ~/.bash_history
	#sed -i '/^git add .*/d' ~/.bash_history
	#sed -i '/^git mv .*/d' ~/.bash_history
	#sed -i '/^stuff .*/d' ~/.bash_history
	#sed -i '/^schedule .*/d' ~/.bash_history
	#sed -i '/^log .*/d' ~/.bash_history
	#sed -i '/^money .*/d' ~/.bash_history
	#sed -i '/^git commit .*/d' ~/.bash_history
	#sed -i '/^[.]/.*/d' ~/.bash_history
	
	# Remove any usage of cd, ls and mpv when only going one folder deeper in file structure
	sed -i -r '/^(cd|ls|mpv|mpv) [^\/\>\<|:&]*\/? ?$/d' ~/.bash_history
	# Remove any usage of ms, msn, rs and pdf when not going into a different folder
	sed -i -r '/^(ms[n]?|rs|pdf) [^\/\>\<|:&]* ?$/d' ~/.bash_history
	# Remove anything in all caps, as it will basically always be a mistype
	sed -i '/^[A-Z0-9 ]*$/d' ~/.bash_history
	# Remove all duplicates, keeping most recent
	tac ~/.bash_history | awk '!x[$0]++' | tac > ~/.bash_history_no_dupes && command mv ~/.bash_history_no_dupes ~/.bash_history
	#sed --in-place 's/[[:space:]]\+$//' .bash_history && awk -i inplace '!seen[$0]++' .bash_history
}

# Get number of files in directory recursively (only non hidden files)
lcr () {
	if [[ "$@" == "." ]]; then
		find "$PWD" -name ".*" -prune -o -type f -print | wc -l
	else
		args="${@//./$PWD}"
		find $args -name ".*" -prune -o -type f -print | wc -l
	fi
}

# Get number of files in directory recursively (including hidden files)
lcra () {
	find "$@" -type f | wc -l
}

# Get all files in directory (recursive)
lsf () {
	for arg; do
		find "${arg}/"** -type f 2> /dev/null | rev | cut -d "/" -f 1 | rev
	done
}

# Get all files in directory (recursive and including hidden)
lsaf () {
	for arg; do
		find "${arg}/"** "${arg}/".** -type f 2> /dev/null | rev | cut -d "/" -f 1 | rev
	done
}

# Swap prompt for anonomous one and back
anonprompt () {
	if [[ "$PS1" == *"user"* ]]; then
		PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
	else
		PS1='\[\033[1;36m\]user\[\033[1;31m\]@\[\033[1;32m\]Laptop:\[\033[1;35m\]\W\[\033[1;31m\]\$\[\033[0m\] '
	fi
}

# Quick preview files with bat and fasd
batf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	bat --theme=base16 "$result"
}

# Quick preview files with glow and fasd
glowf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	glow "$result"
}

# Quick open files with mpv and fasd
mpvf () {
	result=$(fasd -fi $@)
	[ "$result" == "" ] && return
	/usr/bin/mpv --really-quiet --save-position-on-quit "$result" & disown
}

do_mpvr () {
	find "$(pwd)" -mindepth 1 | sort | tac > /tmp/tempPlaylist.m3u
	/usr/bin/mpv --really-quiet --save-position-on-quit /tmp/tempPlaylist.m3u & disown
}

# latexmk helper
do_latexmk () {
	/usr/bin/latexmk -silent -pdf "$1"
	/usr/bin/latexmk -silent -c
}

# Program Openers 

alias p='_p'
alias mpv-yt='do_mpv-yt'
alias m='_m'
alias r='_r'
alias mpv='do_mpv'
alias mpvr='do_mpvr'

# Unix terminal programs 

alias hs='history'
alias his='history | grep'
alias c='clear'
alias cl='clear && ls'
alias x='chmod +x'
alias grep='grep -i --color=auto'
alias greps='/usr/bin/grep --color=auto'
alias grepa='grep -i -I -A 5 -B 5 --color=auto'
alias l='ls --group-directories-first --file-type -N -1 --color=auto'
alias ls='ls --group-directories-first --file-type -N --color=auto'
alias la='ls --group-directories-first --file-type -NA -1 --color=auto'
alias lsa='ls --group-directories-first --file-type -NA --color=auto'
alias lsl='ls --group-directories-first --file-type -N --color=auto -l -h'
alias lsal='ls --group-directories-first --file-type -NA --color=auto -l -h'
alias ld='/usr/bin/ls --group-directories-first -N -1 --color=auto -d */ 2> /dev/null'
alias lda='/usr/bin/ls --group-directories-first -N -1 --color=auto -d */ .*/ 2> /dev/null'
alias lsd='/usr/bin/ls --group-directories-first -N --color=auto -d */ 2> /dev/null'
alias lsdl='/usr/bin/ls --group-directories-first -N --color=auto -l -h -d */ 2> /dev/null'
alias lsda='/usr/bin/ls --group-directories-first -N --color=auto -d */ .*/ 2> /dev/null'
alias lsdal='/usr/bin/ls --group-directories-first -N --color=auto -l -h -d */ .*/ 2> /dev/null'
alias mv='mv -i'
alias cp='cp -i -r'
alias diff='diff --color'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
#alias gpg2='gpg2 --homedir "$XDG_DATA_HOME"/gnupg'
alias cal="unbuffer cal -n 3 | sed '/^ *$/d'"
alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'
alias lsblk='lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS'

# Stream things  

alias destiny='mpv --title=Destiny --ytdl-format=best https://www.youtube.com/@Destiny/live & disown'
alias chudlogic='do_chudlogic'
alias nerdcubed='mpv --title=NerdCubed https://www.twitch.tv/nerdcubed best 2>&1 & disown'
alias dustineden='mpv --title="Dustin Eden" https://www.twitch.tv/dustineden best 2>&1 & disown'
alias matn='mpv --title="Many A True Nerd" https://www.youtube.com/@ManyATrueNerd/live & disown'
alias noahsunday='mpv --title="Noah Sunday - Completionist" https://www.youtube.com/@NoahSundayCompletionist/live & disown'
alias nmixx='mpv --title="NMIXX" https://www.youtube.com/@NMIXXOfficial/live & disown'
alias dgg='firefox https://destiny.gg/embed/chat & disown'
alias streams='~/Programs/terminal/alias/terminalStreamChecker.sh'
alias wstream='~/Programs/terminal/alias/destinyDownload.sh'

# cd Shortcuts 

alias steamapps='cd ~/.local/share/Steam/steamapps/common'
alias papirus='cd /usr/share/icons/Papirus-Dark/32x32/'
alias bac='cd ~/Downloads/BackupMount/'
alias con='cd ~/.config'
alias loc='cd ~/.local/share'
alias doc='cd ~/Documents'
alias dow='cd ~/Downloads/'
alias pic='cd ~/Pictures/'
alias vid='cd ~/Videos'
alias mus='cd ~/Music'
alias pro='cd ~/Programs'
alias cur='cd ~/Music/CurrentPlaylist/'
alias wor='cd ~/Work'
alias bin='cd ~/.local/bin'
alias web='cd ~/Programs/website'

# Shortcuts 

## PacMan
 
alias install='sudo pacman -S'
alias remove='sudo pacman -Rs'
alias update='sudo pacman -Syu'
alias search='pacman -Ss'
alias list='pacman -Qe'
alias pacs='pacman -Q | wc -l'

## yt-dlp 

alias yt-dlp='yt-dlp -o "%(title)s.%(ext)s"'
alias yt-aria='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M" -o "%(title)s.%(ext)s"'
alias yt-aria-limit='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=3M" -o "%(title)s.%(ext)s"'
alias yt-folder='~/Programs/terminal/alias/ytdlpFolder.sh'
alias yt-music='yt-dlp -f 140 -o "%(title)s - %(channel)s - %(album)s.%(ext)s"'
alias yt-playlist='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M" -o "%(title)s.%(ext)s" --embed-chapters --embed-thumbnail --embed-metadata -f 22/bestvideo+bestaudio --cookies-from-browser firefox'
alias yt-playlist-limit='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=3M" -o "%(title)s.%(ext)s" --embed-chapters --embed-thumbnail --embed-metadata -f 22/bestvideo+bestaudio --cookies-from-browser firefox'

## Web Alternatives

alias ytlen='~/Programs/terminal/webAlternatives/youtubeLength.sh'
alias wl='~/Programs/terminal/webAlternatives/watchlater.sh'
alias ythis='~/Programs/terminal/webAlternatives/saveYoutubeHistory.sh'

## Git 

alias gp='git pull'
alias gits='git status'
alias gitd='git diff'
alias gitl='git log --reverse'
alias gitpass='pass -c GitHub/randomcoder67Key'
alias giturl='git config --get remote.origin.url'

## Other 

alias nf='neofetch'
alias py='python3'
alias sq='ncdu'
alias bat='bat --theme=base16'
alias batl='find . -maxdepth 1 | sort | tail -n 1 | xargs bat --theme=base16'
alias q='trim_history && exit'
alias reload='. ~/.bashrc'
alias ghc='ghc -dynamic'
alias balance='aacgain -r -m 1 *.m4a'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias hashfolder='~/Programs/terminal/alias/hashfolder.sh'
alias cmpfolder='~/Programs/terminal/alias/cmpfolder.sh'
alias music='~/Programs/terminal/alias/music.sh'
alias tagmusic='python3 ~/Programs/terminal/terminalPrograms/musicTag/tagMusicFile.py'
alias files='wc -l ~/Programs/output/updated/files.txt'
alias vol='pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g"'
alias mtmv='perl-rename'
alias curloc='cat ~/Programs/output/updated/curLocation.csv | sed "s/|/\n/g"'
alias savedotfiles='~/Programs/configure/save2.sh'
alias songs='cat ~/Programs/output/updated/songs.txt'
alias todo='micro ~/Programs/output/updated/todo.md'
alias emails='mousepad ~/Programs/output/updated/emails.md & disown'
alias lc='ls | wc -l'
alias lca='ls -A | wc -l'
alias lcd='ls -d */ 2> /dev/null | wc -l'
alias lcda='ls -d */ .*/ 2> /dev/null | wc -l'
alias rmedir='find . -type d -empty -delete'
alias gtop='sudo intel_gpu_top'
alias remake='~/Programs/configure/remake.sh'
alias gripdo='grip --theme=dark -b'
alias latexmk='do_latexmk'
alias bookmarks='wc -l ~/Programs/output/updated/bookmarks.txt'
alias serial='sudo cat /sys/devices/virtual/dmi/id/product_serial'

# Info programs 

alias schedule='~/Programs/terminal/terminalPrograms/goBins/schedule'
alias log='~/Programs/terminal/terminalPrograms/goBins/log'
alias dreams='~/Programs/terminal/terminalPrograms/goBins/log -da'
alias weather='goWeather'
alias shows='~/Programs/terminal/alias/shows.sh'
alias money='~/Programs/terminal/terminalPrograms/goBins/money'
alias days='~/Programs/terminal/terminalPrograms/goBins/days'
alias mt='~/Programs/terminal/terminalPrograms/goBins/metricTime'

# File finders 

alias findh='find ~ -iname'
#alias glowf='~/Programs/terminal/alias/findOpen.sh glow'
#alias batf='~/Programs/terminal/alias/findOpen.sh bat'
#alias mpvf='~/Programs/terminal/alias/findOpen.sh mpv'

# My terminal programs 

alias albumart='~/Programs/terminal/terminalPrograms/albumArt.sh'
alias groffdoc='~/Programs/terminal/terminalPrograms/goBins/groffdoc'
alias programs='~/Programs/terminal/alias/addRemove.sh'
alias checkfiles='~/Programs/system/rofi/checkFiles.sh'
alias rm='~/Programs/terminal/alias/rm.sh'
alias backup='~/Programs/terminal/terminalPrograms/backup.sh'
alias stuff='python3 ~/Programs/terminal/terminalPrograms/stuff.py'
alias strava='~/Programs/terminal/terminalPrograms/strava/strava.sh'
alias setlocation='~/Programs/terminal/terminalPrograms/setLocation.sh'
alias sky='~/Programs/terminal/terminalPrograms/astro/planets'
alias timer='~/Programs/terminal/terminalPrograms/goBins/timer'
alias domount='~/Programs/terminal/terminalPrograms/mount.sh'
alias ipodsync='~/Programs/terminal/alias/ipodShuffle.sh'
alias render='~/Programs/terminal/terminalPrograms/goBins/render'
alias downloadt='~/Programs/terminal/terminalPrograms/goBins/downloadTime'

# Fun 

alias asq='asciiquarium'
alias stonehenge='cat ~/Programs/terminal/alias/stonehenge.txt'

HISTSIZE=20000
HISTFILESIZE=20000

export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:~/.local/bin:~/.npm/bin:~/.local/share/npm/bin
export MICRO_TRUECOLOR=1
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PASSWORD_STORE_CLIP_TIME=120

source ~/Programs/output/otherScripts/aliases.sh
source ~/Programs/terminal/autocompletion.bash

#alias a='fasd -a'        # any
#alias s='fasd -si'       # show / search / select
#alias d='fasd -d'        # directory
#alias f='fasd -f'        # file
#alias sd='fasd -sid'     # interactive directory selection
#alias sf='fasd -sif'     # interactive file selection
#alias z='fasd_cd -d'     # cd, same functionality as j in autojump
#alias zz='fasd_cd -d -i'

export _FASD_NOCASE=1
eval "$(fasd --init auto)"
