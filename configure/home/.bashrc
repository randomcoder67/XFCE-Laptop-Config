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


PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\033[1;33m\][\t]\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '

# Functions

mkcdir () {
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}

pdf () {
	for arg; do
		zathura "$arg" & disown
	done
}

mpv_do () {
	for arg; do
		mpv --really-quiet --save-position-on-quit "$arg" & disown
	done
}

rs () {
	inputA=""
	for arg; do
		inputA="$inputA $arg"
	done
	echo $inputA
	ristretto $inputA & disown
}

mpv_do () {
	for arg; do
		mpv --really-quiet --save-position-on-quit "$arg" & disown
	done
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
	mpv --title="Chud Logic" https://www.youtube.com/@ChudLogic/live 2>&1 & disown
	streamlink --player "mpv --title='Chud Logic'" https://www.twitch.tv/chudlogic best 2>&1 & disown
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


# Program openers 

alias ms='~/Programs/terminal/alias/msnew.sh'
alias mpv='mpv_do'

# Unix terminal programs 

alias gp='git pull'
alias his='history | grep'
alias c='clear'
alias cl='clear && ls'
alias x='chmod +x'
alias grep='grep -i --color=auto'
alias grepa='grep -i -A 5 -B 5 --color=auto'
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
alias matn='mpv --title="Many A True Nerd" https://www.youtube.com/@ManyATrueNerd/live & disown'
alias dgg='surf https://destiny.gg/embed/chat & disown'
alias streams='~/Programs/terminal/alias/streamsCheck.sh'
alias wstream='~/Programs/terminal/alias/destinyDownload.sh'

# cd Shortcuts 

alias steamapps='cd ~/.local/share/Steam/steamapps/common'

# Shortcuts 

alias nf='neofetch'
alias py='python3'
alias sq='ncdu'
alias q='trim_history && exit'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rs'
alias update='sudo pacman -Syu'
alias reload='. ~/.bashrc'
alias ghc='ghc -dynamic'
alias balance='aacgain -r -m 1 *.m4a'
alias clearlogs='sudo journalctl --vacuum-time=2d'
alias yt-aria='yt-dlp --external-downloader aria2c --external-downloader-args "-x 16 -j 16 -s 16 -k 1M"'

# Info programs 

alias fitness='~/Programs/terminal/terminalPrograms/fitness.sh'
alias schedule='~/Programs/terminal/terminalPrograms/schedule.sh'
alias log='python3 ~/Programs/terminal/log.py'
alias weather='curl wttr.in'

# File finders 

alias findh='find ~ -iname'
alias glowf='~/Programs/terminal/alias/findOpen.sh glow'
alias batf='~/Programs/terminal/alias/findOpen.sh bat'
alias mpvf='~/Programs/terminal/alias/findOpen.sh mpv'

# My terminal programs 

alias albumart='~/Programs/terminal/albumArt.sh'
alias groffdoc='python3 ~/Programs/terminal/mdToGroff.py'
alias programs='~/Programs/terminal/addRemove.sh'
alias checkfiles='~/Programs/system/rofi/checkFiles.sh'
alias rm='~/Programs/terminal/alias/rm.sh'

HISTSIZE=20000
HISTFILESIZE=20000

export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:~/.local/bin

