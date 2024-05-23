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
			COMPREPLY=( $(compgen -W "-f -m -s" -- "${COMP_WORDS[COMP_CWORD]}") )
			return 0
		else
			return 0
		fi
	fi
	COMPREPLY=( $(compgen -W "-h -a -f -m -s" -- "${COMP_WORDS[1]}") )
}

_savedotfilesCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "$(grep -A 2 'Options are' ~/Programs/configure/save.sh | tail -n 2 | sed 's/echo \"  //g' | tr -d \"\"\")" -- "${COMP_WORDS[1]}") )
}

_removeCompletion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return 0
	fi
	COMPREPLY=( $(compgen -W "$(pacman -Q | cut -d ' ' -f 1)" -- "${COMP_WORDS[1]}") )
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

_yt-dlpCompletion() {
    local cur prev opts fileopts diropts keywords
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--aria --aria-limit --all-metadata --archive --music --standard --firefox-cookies --help --version --update --no-update --update-to --ignore-errors --no-abort-on-error --abort-on-error --dump-user-agent --list-extractors --extractor-descriptions --use-extractors --force-generic-extractor --default-search --ignore-config --no-config-locations --config-locations --flat-playlist --no-flat-playlist --live-from-start --no-live-from-start --wait-for-video --no-wait-for-video --mark-watched --no-mark-watched --no-colors --color --compat-options --alias --proxy --socket-timeout --source-address --impersonate --list-impersonate-targets --force-ipv4 --force-ipv6 --enable-file-urls --geo-verification-proxy --cn-verification-proxy --xff --geo-bypass --no-geo-bypass --geo-bypass-country --geo-bypass-ip-block --playlist-start --playlist-end --playlist-items --match-title --reject-title --min-filesize --max-filesize --date --datebefore --dateafter --min-views --max-views --match-filters --no-match-filters --break-match-filters --no-break-match-filters --no-playlist --yes-playlist --age-limit --download-archive --no-download-archive --max-downloads --break-on-existing --no-break-on-existing --break-on-reject --break-per-input --no-break-per-input --skip-playlist-after-errors --include-ads --no-include-ads --concurrent-fragments --limit-rate --throttled-rate --retries --file-access-retries --fragment-retries --retry-sleep --skip-unavailable-fragments --abort-on-unavailable-fragments --keep-fragments --no-keep-fragments --buffer-size --resize-buffer --no-resize-buffer --http-chunk-size --test --playlist-reverse --no-playlist-reverse --playlist-random --lazy-playlist --no-lazy-playlist --xattr-set-filesize --hls-prefer-native --hls-prefer-ffmpeg --hls-use-mpegts --no-hls-use-mpegts --download-sections --downloader --downloader-args --batch-file --no-batch-file --id --paths --output --output-na-placeholder --autonumber-size --autonumber-start --restrict-filenames --no-restrict-filenames --windows-filenames --no-windows-filenames --trim-filenames --no-overwrites --force-overwrites --no-force-overwrites --continue --no-continue --part --no-part --mtime --no-mtime --write-description --no-write-description --write-info-json --no-write-info-json --write-annotations --no-write-annotations --write-playlist-metafiles --no-write-playlist-metafiles --clean-info-json --no-clean-info-json --write-comments --no-write-comments --load-info-json --cookies --no-cookies --cookies-from-browser --no-cookies-from-browser --cache-dir --no-cache-dir --rm-cache-dir --write-thumbnail --no-write-thumbnail --write-all-thumbnails --list-thumbnails --write-link --write-url-link --write-webloc-link --write-desktop-link --quiet --no-quiet --no-warnings --simulate --no-simulate --ignore-no-formats-error --no-ignore-no-formats-error --skip-download --print --print-to-file --get-url --get-title --get-id --get-thumbnail --get-description --get-duration --get-filename --get-format --dump-json --dump-single-json --print-json --force-write-archive --newline --no-progress --progress --console-title --progress-template --progress-delta --verbose --dump-pages --write-pages --load-pages --youtube-print-sig-code --print-traffic --call-home --no-call-home --encoding --legacy-server-connect --no-check-certificates --prefer-insecure --user-agent --referer --add-headers --bidi-workaround --sleep-requests --sleep-interval --max-sleep-interval --sleep-subtitles --format --format-sort --format-sort-force --no-format-sort-force --video-multistreams --no-video-multistreams --audio-multistreams --no-audio-multistreams --all-formats --prefer-free-formats --no-prefer-free-formats --check-formats --check-all-formats --no-check-formats --list-formats --list-formats-as-table --list-formats-old --merge-output-format --allow-unplayable-formats --no-allow-unplayable-formats --write-subs --no-write-subs --write-auto-subs --no-write-auto-subs --all-subs --list-subs --sub-format --sub-langs --username --password --twofactor --netrc --netrc-location --netrc-cmd --video-password --ap-mso --ap-username --ap-password --ap-list-mso --client-certificate --client-certificate-key --client-certificate-password --extract-audio --audio-format --audio-quality --remux-video --recode-video --postprocessor-args --keep-video --no-keep-video --post-overwrites --no-post-overwrites --embed-subs --no-embed-subs --embed-thumbnail --no-embed-thumbnail --embed-metadata --no-embed-metadata --embed-chapters --no-embed-chapters --embed-info-json --no-embed-info-json --metadata-from-title --parse-metadata --replace-in-metadata --xattrs --concat-playlist --fixup --prefer-avconv --prefer-ffmpeg --ffmpeg-location --exec --no-exec --exec-before-download --no-exec-before-download --convert-subs --convert-thumbnails --split-chapters --no-split-chapters --remove-chapters --no-remove-chapters --force-keyframes-at-cuts --no-force-keyframes-at-cuts --use-postprocessor --sponsorblock-mark --sponsorblock-remove --sponsorblock-chapter-title --no-sponsorblock --sponsorblock-api --sponskrub --no-sponskrub --sponskrub-cut --no-sponskrub-cut --sponskrub-force --no-sponskrub-force --sponskrub-location --sponskrub-args --extractor-retries --allow-dynamic-mpd --ignore-dynamic-mpd --hls-split-discontinuity --no-hls-split-discontinuity --extractor-args --youtube-include-dash-manifest --youtube-skip-dash-manifest --youtube-include-hls-manifest --youtube-skip-hls-manifest"
    keywords=":ytfavorites :ytrecommended :ytsubscriptions :ytwatchlater :ythistory"
    fileopts="--batch-file|--download-archive|--cookies|--load-info"
    #fileopts="-a|--batch-file|--download-archive|--cookies|--load-info"
    diropts="--cache-dir"


    if [[ ${prev} =~ ${fileopts} ]]; then
        COMPREPLY=( $(compgen -f -- ${cur}) )
        return 0
    elif [[ ${prev} =~ ${diropts} ]]; then
        COMPREPLY=( $(compgen -d -- ${cur}) )
        return 0
    fi
    if [[ ${cur} =~ : ]]; then
        COMPREPLY=( $(compgen -W "${keywords}" -- ${cur}) )
        return 0
    elif [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
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
complete -o default rsync
complete -o default pkgfile
complete -o default dragon
complete -F _yt-dlpCompletion yt-dlp
