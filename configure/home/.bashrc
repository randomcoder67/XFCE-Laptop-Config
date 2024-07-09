#
# ~/.bashrc
#

PROMPT_COMMAND=
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

# Functions

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

# Grep but only show surrounding characters, useful for files with very long lines, like a lot of HTML files
grepc () {
	grep --color=no -i -I -o -P ".{0,100}$1.{0,100}" $2 | grep "$1"
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

# Open files with Mousepad (normal)
ms () {
	for arg; do
		mousepad "$arg" & disown
	done
}

# Open files with Mousepad in a new window (normal)
msn () {
	mousepad -o window & disown
	sleep 0.2
	for arg; do
		mousepad "$arg" & disown
	done
}

# Open video(s) with mpv (normal)
mp () {
	/usr/bin/mpv --really-quiet --save-position-on-quit "$@" & disown
}

# Open YouTube video with mpv
mp-yt () {
	/usr/bin/mpv --really-quiet --title='${media-title}' --ytdl-format='bestvideo[protocol*=m3u8][height<=2160][vcodec*=avc1]+bestaudio[protocol*=m3u8]' "$@" & disown
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

# Search root directory
findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

# Search given directory (current if none specified)
findc () {
	dirName="."
	if [[ "$2" != "" ]]; then
		dirName="$2"
	fi
	find "$dirName" -iname "$1"
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
	TZ="Europe/Paris" date +"  Paris:          %H:%M:%S - %a, %b %d (%Z)"
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

mpvr () {
	find "$(pwd)" -mindepth 1 | sort | tac > /tmp/tempPlaylist.m3u
	/usr/bin/mpv --really-quiet --save-position-on-quit /tmp/tempPlaylist.m3u & disown
}

# latexmk helper
do_latexmk () {
	/usr/bin/latexmk -silent -pdf "$1"
	/usr/bin/latexmk -silent -c
}

do_yt-dlp () {
	local aria_args=()
	local metadata_args=()
	local cookies_args=()
	local archive_args=()
	local other_args=()
	output_format_args=(-o "%(title)s.%(ext)s")
	format_args=()
	
	while [[ $# -gt 0 ]]; do
		case "$1" in
			--aria)
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M")
				shift
				;;
			--aria-limit)
				download_limit="3"
				num_re='^[0-9]+$'
				if [[ "$2" =~ $num_re ]]; then
					download_limit="$2"
					shift
				fi
				aria_args+=("--external-downloader" "aria2c" "--external-downloader-args" "aria2c:-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=${download_limit}M")
				shift
				;;
			--all-metadata)
				metadata_args+=("--embed-chapters" "--embed-thumbnail" "--embed-metadata")
				shift
				;;
			--music)
				output_format_args=(-o "%(title)s - %(channel)s - %(album)s.%(ext)s")
				format_args=(-f 140)
				shift
				;;
			--standard)
				format_args=(-f "22/bestvideo[height<=720]+bestaudio")
				shift
				;;
			--firefox-cookies)
				cookies_args=("--cookies-from-browser" "firefox")
				shift
				;;
			--archive)
				archive_args=("--download-archive" "archive.txt")
				shift
				;;
			*)
				other_args+=("$1")
				shift
				;;
		esac
	done
	
	
	local all_args=("${output_format_args[@]}" "${aria_args[@]}" "${metadata_args[@]}" "${cookies_args[@]}" "${format_args[@]}" "${archive_args[@]}" "${other_args[@]}" "$@")
	/usr/bin/yt-dlp "${all_args[@]}"
}

archiveplaylist() {
	yt-dlp --firefox-cookies -J --flat-playlist "$1" | jq '.entries[] | [.title,.channel,.url]| @csv' > "$2"
}

streamchecker () {
	status="$1"
	if [[ "$status" == "-e" ]]; then
		toSet="enabled"
		echo "enabled" > "$HOME/Programs/output/updated/enablePanelCheckers.txt"
		echo "Panel Stream Checkers Enabled"
	elif [[ "$status" == "-d" ]]; then
		echo "disabled" > "$HOME/Programs/output/updated/enablePanelCheckers.txt"
		echo "Panel Stream Checkers Disabled"
	elif [[ "$status" == "-m" ]]; then
		"$HOME/Programs/system/panel/manualPanelRefresh.sh"
		echo "Triggered manual panel refresh"
	fi
}

## yt-dlp 

#alias yt-dlp='do_yt-dlp'
alias yt-music='/usr/bin/yt-dlp -f 140 -o "%(title)s - %(channel)s - %(album)s.%(ext)s"'
alias yt-folder='~/Programs/terminal/alias/ytdlpFolder.sh'
#alias yt-playlist='/usr/bin/yt-dlp -f 22/bestvideo+bestaudio --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M" --embed-chapters --embed-thumbnail --embed-metadata -o "%(title)s - %(channel)s.%(ext)s"'
alias yt-dlp='do_yt-dlp'

# Unix terminal programs 

alias hs='history'
alias his='history | grep'
alias c='clear'
alias cl='clear && ls'
alias x='chmod +x'
alias grep='grep -i --color=auto'
alias greps='/usr/bin/grep --color=auto'
alias grepa='grep -i -I -A 5 -B 5 --color=auto'
alias l='ls --group-directories-first --file-type -N -1 -h --color=auto'
alias ls='ls --group-directories-first --file-type -N -h --color=auto'
alias la='ls --group-directories-first --file-type -NA -1 -h --color=auto'
alias lsa='ls --group-directories-first --file-type -NA -h --color=auto'
alias ld='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ 2> /dev/null'
alias lda='/usr/bin/ls --group-directories-first -N -1 -h --color=auto -d */ .*/ 2> /dev/null'
alias lsd='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ 2> /dev/null'
alias lsda='/usr/bin/ls --group-directories-first -N -h --color=auto -d */ .*/ 2> /dev/null'
alias diff='diff --color'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias cal="unbuffer cal -n 3 | sed '/^ *$/d'"
alias as='echo "Use \as to run as command, disabled as too easy to type accidentally, creating unnecessary a.out file in home directory"'
alias lsblk='lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,FSTYPE,MOUNTPOINTS'

# Stream things  

alias streams='~/Programs/terminal/alias/terminalStreamChecker.sh'

# cd Shortcuts 

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

## Web Alternatives

alias ytlen='~/Programs/terminal/webAlternatives/youtubeLength.sh'
alias wl='~/Programs/terminal/webAlternatives/watchlater.sh'
alias ythis='~/Programs/terminal/webAlternatives/saveYoutubeHistory.sh'

## Git 

alias gp='git push'
alias gpl='git pull'
alias gits='git status'
alias gitd='git diff'
alias gitdc='git diff --word-diff-regex=.'
alias gitl='git log --reverse'
alias gitpass='pass -c GitHub/randomcoder67Key'
alias giturl='git config --get remote.origin.url'

## Other 

alias nf='neofetch'
alias py='python3'
alias sq='ncdu --color dark'
alias ra='ranger'
alias bat='bat --theme=base16'
alias batl='find . -maxdepth 1 | sort | tail -n 1 | xargs bat --theme=base16'
alias q='trim_history && exit'
alias reload='. ~/.bashrc'
alias balance='aacgain -r -m 1 *.m4a'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias hashfolder='~/Programs/terminal/alias/hashfolder.sh'
alias cmpfolder='~/Programs/terminal/alias/cmpfolder.sh'
alias music='~/Programs/terminal/alias/music.sh'
alias files='wc -l ~/Programs/output/updated/files.txt'
alias vol='pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | cut -d "/" -f 2 | sed "s/ //g"'
alias curloc='cat ~/Programs/output/updated/curLocation.csv | sed "s/|/\n/g"'
alias savedotfiles='~/Programs/configure/save2.sh'
alias todo='micro ~/Programs/output/updated/todo.md'
alias rmedir='find . -type d -empty -delete'
alias gtop='sudo intel_gpu_top'
alias latexmk='do_latexmk'
alias serial='sudo cat /sys/devices/virtual/dmi/id/product_serial'
alias pyweb='python3 -m http.server -d'
alias cmatrix='cmatrix -u 6'

alias duf='duf -hide special'
alias rss='newsboat; podboat'

function songs () {
	if [[ "$1" == "-e" ]]; then
		"$VISUAL" ~/Programs/output/updated/songs.txt
	else
		cat ~/Programs/output/updated/songs.txt
	fi
}

function tmux () {
	oldterm="$TERM"
	export TERM="xterm-kitty"
	/usr/bin/tmux "$@"
	export TERM="$oldterm"
}
alias trash-size='du ~/.local/share/Trash/files/ -s -h | cut -f 1'

# Info programs 

alias dreams='~/Programs/terminal/terminalPrograms/goBins/log -da'
alias weather='goWeather'

# File finders 

alias findh='find ~ -iname'
alias fig='find . | grep'
alias psg='ps -aux | grep'

# My terminal programs 

alias rm='~/Programs/terminal/alias/rm.sh'
#alias mv='~/Programs/terminal/alias/mv.sh -m'
#alias cp='~/Programs/terminal/alias/mv.sh -c'
alias mv='mv -i'
alias cp='cp -r -i'

# Fun 

alias stonehenge='cat ~/Programs/terminal/alias/stonehenge.txt'

# Scripts (aliases that are just quick ways to type a path)

alias remake='~/Programs/configure/remake.sh'
alias schedule='~/Programs/terminal/terminalPrograms/goBins/schedule'
alias log='~/Programs/terminal/terminalPrograms/goBins/log'
alias shows='~/Programs/terminal/alias/shows.sh'
alias money='~/Programs/terminal/terminalPrograms/goBins/money'
alias days='~/Programs/terminal/terminalPrograms/goBins/days'
alias mt='~/Programs/terminal/terminalPrograms/goBins/metricTime'
alias tagmusic='python3 ~/Programs/terminal/terminalPrograms/musicTag/tagMusicFile.py'
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
alias albumart='~/Programs/terminal/terminalPrograms/albumArt.sh'
alias groffdoc='~/Programs/terminal/terminalPrograms/goBins/groffdoc'
alias programs='~/Programs/terminal/alias/addRemove.sh'
alias checkfiles='~/Programs/system/rofi/checkFiles.sh'
alias calories='~/Programs/terminal/terminalPrograms/calories.sh'
alias speedwatch='python3 ~/Programs/terminal/alias/speed.py'
alias polls='python3 ~/Programs/myRepos/terminalPolling/polling.py'

alias sync='echo "Syncing"; sync; echo "Done"; lsblk'

HISTSIZE=40000
HISTFILESIZE=40000

export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:~/.local/bin:~/.npm/bin:~/.local/share/npm/bin
export MICRO_TRUECOLOR=1
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export PASSWORD_STORE_CLIP_TIME=120

source ~/Programs/output/otherScripts/aliases.sh
source ~/Programs/terminal/autocompletion.bash

export _FASD_NOCASE=1
eval "$(fasd --init auto)"

unalias a
unalias s
unalias sd
unalias sf
