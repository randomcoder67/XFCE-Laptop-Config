#!/usr/bin/env bash

backupCurrent="$HOME/Programs/output/updated/backup.txt"

# Gets output of file and matches the lines within, but case insensitive
_caseInsensitive() {
  local sonames=( $(cat $backupCurrent) )
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
		else
			return 0
		fi
	fi
	suggestions=( $(compgen -W "make list ls add remove diff time" -- "${COMP_WORDS[1]}") )
	COMPREPLY=$suggestions
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
		return 0
	fi
	COMPREPLY=( $(compgen -W "-h -p -ds -s -f -fa" -- "${COMP_WORDS[1]}") )
}

_scheduleCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		if [ "${COMP_WORDS[1]}" == "-a" ] && [ "${#COMP_WORDS[@]}" == "4" ]; then # day string options
			COMPREPLY=( $(compgen -W "t tm mon tue wed thu fri sat sun nmon ntue nwed nthu nfri nsat nsun" -- "${COMP_WORDS[3]}") )
			return 0
		else
			return 0
		fi
	fi
	COMPREPLY=( $(compgen -W "-h -n -a" -- "${COMP_WORDS[1]}") )
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
