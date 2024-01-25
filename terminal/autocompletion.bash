#!/usr/bin/env bash

# Autocompletion for my programs/scripts

backupCurrent="$HOME/Programs/output/updated/backup.txt"

# Gets output of file and matches the lines within, but case insensitive
_caseInsensitive() {
  local sonames=( $(cat $backupCurrent | sed 's/\(.*\)/~\1/g') )
  local prefix="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(printf %s\\n "${sonames[@]}" |
			   awk -v IGNORECASE=1 -v p="$prefix" \
				   'p==substr($0,0,length(p))'))
}

_backupCompletion () {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		if [ "${COMP_WORDS[1]}" == "add" ]; then # "add" suggests files
			compopt -o default
			COMPREPLY=()
			return 0
		elif [ "${COMP_WORDS[1]}" == "remove" ]; then # "remove" suggests files in backup.txt
			_caseInsensitive $backupCurrent
			return 0
		elif [ "${COMP_WORDS[1]}" == "time" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then # "remove" suggests files in backup.txt
			COMPREPLY=( $(compgen -W "-a" -- "${COMP_WORDS[2]}") )
			return 0
		else
			return 0
		fi
	fi
	COMPREPLY=( $(compgen -W "make list ls add remove diff time" -- "${COMP_WORDS[1]}") )
	#COMPREPLY=$suggestions this causes it to just paste first one. Why?
}

_getpassCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-c" -- "${COMP_WORDS[1]}") )
}

_programsCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-a -d -h" -- "${COMP_WORDS[1]}") )
}

_albumartCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-d" -- "${COMP_WORDS[1]}") )
}

_groffdocCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	compopt -o default
	COMPREPLY=()
}

_stuffCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-h -e -s -a" -- "${COMP_WORDS[1]}") )
}

_timerCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-h -s" -- "${COMP_WORDS[1]}") )
}

_daysCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "-a" -- "${COMP_WORDS[1]}") )
}

_logCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		if [ "${COMP_WORDS[1]}" == "-d" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then # If -d was chosen, then display the avalible years/months
			if [ ${#COMP_WORDS[2]} -ge 4 ]; then # If month already filled, start showing avalible days
				curLogMonth=${COMP_WORDS[2]:0:4} # Get month in yymm format
				[ -f ~/Programs/output/log/${curLogMonth}.json ] || return 0 # Check that month exists, if not, don't continue
				curMonthSuggestions=$(cat ~/Programs/output/log/$curLogMonth.json | jq -r 'keys[]' | sed "s/\(.*\)/$curLogMonth\1/g") # Get the days avalible in given month
				COMPREPLY=( $(compgen -W "$curMonthSuggestions" -- "${COMP_WORDS[2]}") )
				[[ ${#COMPREPLY} == 4 ]] && compopt -o nospace
				return 0
			else # Otherwise just show avalible months
				COMPREPLY=( $(compgen -W "$(ls ~/Programs/output/log/ | grep -oE '[0-9]*')" -- "${COMP_WORDS[2]}") )
				[[ ${#COMPREPLY} == 4 ]] && compopt -o nospace
				return 0
			fi
		elif [ "${COMP_WORDS[1]}" == "-ds" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then # If -ds was chosen, show avalible months
			COMPREPLY=( $(compgen -W "$(ls ~/Programs/output/log/ | grep -oE [0-9]*)" -- "${COMP_WORDS[2]}") )
		fi
		return 0
	fi
	COMPREPLY=( $(compgen -W "-h -p -d -ds -s -f -fa" -- "${COMP_WORDS[1]}") )
}

_scheduleCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		if [ "${COMP_WORDS[1]}" == "-a" ] && [ "${#COMP_WORDS[@]}" == "4" ]; then # day string options
			COMPREPLY=( $(compgen -W "t tm mon tue wed thu fri sat sun nmon ntue nwed nthu nfri nsat nsun" -- "${COMP_WORDS[3]}") )
			return 0
		elif [ "${COMP_WORDS[1]}" == "-m" ] && [ "${#COMP_WORDS[@]}" == "3" ]; then
			COMPREPLY=( $(compgen -W "t tm mon tue wed thu fri sat sun nmon ntue nwed nthu nfri nsat nsun" -- "${COMP_WORDS[3]}") )
			return 0
		else
			return 0
		fi
	fi
	COMPREPLY=( $(compgen -W "-h -n -i -a -m -d" -- "${COMP_WORDS[1]}") )
}

_moneyCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		if [ "${#COMP_WORDS[@]}" == "4" ] || [ "${#COMP_WORDS[@]}" == "6" ]; then # up to three of these options can be specified
			COMPREPLY=( $(compgen -W "-f -d -s" -- "${COMP_WORDS[COMP_CWORD]}") )
			return 0
		else
			return 0
		fi
	fi
	COMPREPLY=( $(compgen -W "-h -a -f -d -s" -- "${COMP_WORDS[1]}") )
}

_savedotfilesCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "$(grep -A 2 'Options are' ~/Programs/configure/save.sh | tail -n 2 | sed 's/	echo \"  //g' | tr -d \"\"\")" -- "${COMP_WORDS[1]}") )
}

_removeCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "$(pacman -Qe | cut -d ' ' -f 1)" -- "${COMP_WORDS[1]}") )
}

_musicCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "--next --prev --choice -a -al" -- "${COMP_WORDS[1]}") )
}

_remakeCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "$(cat ~/Programs/configure/remake.sh | grep '$1' | cut -d \" -f 4)" -- "${COMP_WORDS[1]}") )
} 

complete -F _backupCompletion backup
complete -F _getpassCompletion getpass
complete -F _programsCompletion programs
complete -F _albumartCompletion albumart
complete -F _groffdocCompletion groffdoc
complete -F _stuffCompletion stuff
complete -F _timerCompletion timer
complete -F _daysCompletion days
complete -F _logCompletion log
complete -F _scheduleCompletion schedule
complete -F _moneyCompletion money
complete -F _savedotfilesCompletion savedotfiles
complete -F _removeCompletion remove
complete -F _musicCompletion music
complete -F _remakeCompletion remake
complete -o default glow
complete -o default pkgfile
complete -o default dragon
