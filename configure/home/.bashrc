#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
	source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

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

mkcdir () {
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	[[ "$yesOrNoShutdown" == "y" ]] && /usr/bin/shutdown -h 0
}

reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	[[ "$yesOrNoReboot" == "y" ]] && /usr/bin/reboot
}

pdf () {
	for arg; do
		zathura "$arg" & disown
	done
}

ms () {
	for arg; do
		mousepad "$arg" & disown
	done
}

msn () {
	mousepad -o window & disown
	sleep 0.2
	for arg; do
		mousepad "$arg" & disown
	done
}

mpv_do () {
	/usr/bin/mpv --really-quiet --save-position-on-quit "$@" & disown
}

rs () {
	inputA=""
	for arg; do
		inputA="$inputA $arg"
	done
	echo $inputA
	ristretto $inputA & disown
}

tmsumv () {
	mv "$1" "$2" && tmsu repair --manual "$1" "$2"
}

view () {
	tmsu files "$1" | grep -P ".jpg|.jpeg|.png|.webp" | xargs ristretto & disown
}

findr () {
	find / -iname "$1" 2>&1 | grep -v 'Permission denied'
}

chudLogic () {
	/usr/bin/mpv --title="Chud Logic" https://www.youtube.com/@ChudLogic/live 2>&1 & disown
	/usr/bin/mpv --title="Chud Logic" https://www.twitch.tv/chudlogic best 2>&1 & disown
}

t () {
	TZ="America/Los_Angeles" date +"Los Angeles: 	%H:%M:%S - %a, %b %d (%Z)"
	TZ="America/New_York" date +"New York: 	%H:%M:%S - %a, %b %d (%Z)"
	date -u +"UTC: 		%H:%M:%S - %a, %b %d (%Z)"
	TZ="Europe/London" date +"London: 	%H:%M:%S - %a, %b %d (%Z)"
	TZ="Asia/Seoul" date +"Seoul: 		%H:%M:%S - %a, %b %d (%Z)"
	TZ="Australia/Sydney" date +"Sydney: 	%H:%M:%S - %a, %b %d (%Z)"
}	

trim_history () {
	sed -i '/^q$/d' ~/.bash_history
	sed -i '/^ls$/d' ~/.bash_history
	sed -i '/^l$/d' ~/.bash_history
	sed -i '/^lsa$/d' ~/.bash_history
	sed -i '/^exit$/d' ~/.bash_history
	sed -i '/^c$/d' ~/.bash_history
	sed -i '/^cl$/d' ~/.bash_history
	sed -i '/^cd$/d' ~/.bash_history
	sed -i '/^rm$/d' ~/.bash_history
	sed -i '/^x$/d' ~/.bash_history
	#sed --in-place 's/[[:space:]]\+$//' .bash_history && awk -i inplace '!seen[$0]++' .bash_history
}

# Program Openers 

alias mpv='mpv_do'

# Unix terminal programs 

alias gp='git pull'
alias his='history | grep'
alias c='clear'
alias cl='clear && ls'
alias x='chmod +x'
alias grep='grep -i --color=auto'
alias grepa='grep -i -A 5 -B 5 --color=auto'
alias l='ls --group-directories-first --file-type -N --color=auto'
alias ls='ls --group-directories-first --file-type -N --color=auto'
alias lsa='ls --group-directories-first --file-type -NA --color=auto'
alias mv='mv -i'
alias cp='cp -i -r'
alias diff='diff --color'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
#alias gpg2='gpg2 --homedir "$XDG_DATA_HOME"/gnupg'

# Stream things  

alias destiny='~/Programs/terminal/alias/destiny.sh'
alias chudlogic='chudLogic'
alias nerdcubed='streamlink --player "mpv --title=NerdCubed" https://www.twitch.tv/nerdcubed best 2>&1 & disown'
alias dustineden='streamlink --player "mpv --title=\"Dustin Eden\" https://www.twitch.tv/dustineden best 2>&1 & disown'
alias matn='mpv --title="Many A True Nerd" https://www.youtube.com/@ManyATrueNerd/live & disown'
alias dgg='surf https://destiny.gg/embed/chat & disown'
alias streams='~/Programs/terminal/alias/streamsCheck.sh'
alias wstream='~/Programs/terminal/alias/destinyDownload.sh'

# cd Shortcuts 

alias steamapps='cd ~/.local/share/Steam/steamapps/common'
alias papirus='cd /usr/share/icons/Papirus-Dark/32x32/'
alias cdb='cd ~/Downloads/BackupMount/'
alias con='cd ~/.config'
alias loc='cd ~/.local/share'
alias doc='cd ~/Documents'
alias dow='cd ~/Downloads/'
alias pic='cd ~/Pictures/'
alias vid='cd ~/Videos'
alias mus='cd ~/Music'
alias pro='cd ~/Programs'
alias cur='cd ~/Music/curPlaylist/'

# Shortcuts 

alias nf='neofetch'
alias py='python3'
alias sq='ncdu'
alias bat='bat --theme=base16'
alias q='trim_history && exit'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rs'
alias update='sudo pacman -Syu'
alias search='pacman -Ss'
alias list='pacman -Qe'
alias reload='. ~/.bashrc'
alias ghc='ghc -dynamic'
alias balance='aacgain -r -m 1 *.m4a'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias yt-dlp='yt-dlp -o "%(title)s.%(ext)s"'
alias yt-aria='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M" -o "%(title)s.%(ext)s"'
alias yt-aria-limit='yt-dlp --external-downloader aria2c --external-downloader-args aria2c:"-x 16 -j 16 -s 16 -k 1M --max-overall-download-limit=3M" -o "%(title)s.%(ext)s"'
alias hashfolder='~/Programs/terminal/alias/hashfolder.sh'
alias cmpfolder='~/Programs/terminal/alias/cmpfolder.sh'
alias music='~/Programs/terminal/alias/music.sh'
alias yt-music='yt-dlp -f 140 -o "%(title)s - %(channel)s - %(album)s.%(ext)s"'
alias tagmusic='python3 ~/Programs/smallPrograms/musicTag/tagMusicFile.py'
alias gits='git status'
alias gitd='git diff'
alias gitpass='pass -c GitHub/randomcoder67Key'
alias pacs='pacman -Q | wc -l'
alias files='wc -l ~/Programs/output/updated/files.txt'
alias mtmv='perl-rename'
alias curloc='cat ~/Programs/output/updated/curLocation.csv | sed "s/|/\n/g"'

# Info programs 

alias fitness='~/Programs/terminal/terminalPrograms/fitness.sh'
alias schedule='~/Programs/terminal/terminalPrograms/schedule'
alias log='~/Programs/terminal/terminalPrograms/log'
alias weather='python3 ~/Programs/smallPrograms/metOffice/metOffice.py'
alias shows='~/Programs/terminal/shows.sh'

# File finders 

alias findh='find ~ -iname'
alias glowf='~/Programs/terminal/alias/findOpen.sh glow'
alias batf='~/Programs/terminal/alias/findOpen.sh bat'
alias mpvf='~/Programs/terminal/alias/findOpen.sh mpv'

# My terminal programs 

alias albumart='~/Programs/terminal/terminalPrograms/albumArt.sh'
alias groffdoc='python3 ~/Programs/terminal/terminalPrograms/mdToGroff.py'
alias programs='~/Programs/terminal/addRemove.sh'
alias checkfiles='~/Programs/system/rofi/checkFiles.sh'
alias rm='~/Programs/terminal/alias/rm.sh'
alias backup='~/Programs/terminal/terminalPrograms/backup.sh'
alias stuff='python3 ~/Programs/terminal/terminalPrograms/stuff.py'
alias strava='~/Programs/smallPrograms/strava/strava.sh'
alias cycling='python3 ~/Programs/smallPrograms/proCyclingStats/getInfo.py'
alias setlocation='~/Programs/terminal/terminalPrograms/setLocation.sh'
alias getpass='~/Programs/terminal/alias/passGen.sh'
alias sky='~/Programs/terminal/terminalPrograms/astro/planets'

# Fun 

alias asq='asciiquarium'

HISTSIZE=20000
HISTFILESIZE=20000

export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:~/.local/bin:~/.npm/bin
export EDITOR="nano"
export VISUAL="micro"
export MICRO_TRUECOLOR=1
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

#alias a='fasd -a'		# any
#alias s='fasd -si'	   # show / search / select
#alias d='fasd -d'		# directory
#alias f='fasd -f'		# file
#alias sd='fasd -sid'	 # interactive directory selection
#alias sf='fasd -sif'	 # interactive file selection
#alias z='fasd_cd -d'	 # cd, same functionality as j in autojump
#alias zz='fasd_cd -d -i'

eval "$(fasd --init auto)"
