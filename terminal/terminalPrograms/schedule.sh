#!/usr/bin/env bash

IFS=$'\n'

getFileName () {
	if [[ "$1" == "" ]]; then
		toUse=$(date +"%y%m%d")
	else
		toUse=$1
	fi
	week=$(date --date=$toUse +"%W")
	newYear="${toUse:0:2}"
	if [[ $week = "00" ]]; then
		curYear="${toUse:0:2}"
		newYear=$((curYear-1))
		week=$(date --date="$newYear"1231 +"%W")
	fi
	echo ~/Programs/output/schedule/$newYear$week".csv"
}

printSchedule () {
	if ! [ -f "$1" ]; then
		exit
	fi
	items=( $(cat $1 | sort) ) # Get the items in file

	# Associative array to remove duplicate dates
	declare -A nodupes
	for x in "${items[@]}"; do
		first=$(echo "$x" | cut -d\, -f1)
		nodupes["$first"]="blank"
	done

	# Getting keys to get only dates
	presentDates=()
	for i in "${!nodupes[@]}"; do
		presentDates+=("${i}")
	done

	# Sort these dates
	presentDatesSorted=($(sort <<<"${presentDates[*]}"))

	echo "# Schedule" > ~/Programs/output/.temp/schedule.md

	for x in "${presentDatesSorted[@]}"; do
		curDates=()
		for entryA in "${items[@]}"; do
			if [[ "$entryA" == *"$x"* ]]; then
				curDates+=("$entryA")
			fi
		done

		# Associative array to remove duplicate times
		nodupes=()
		for xx in "${curDates[@]}"; do
			first=$(echo "$xx" | cut -d\, -f2)
			nodupes["$first"]="blank"
		done

		# Getting keys to get only times
		presentTimes=()
		for i in "${!nodupes[@]}"; do
			#echo ${i}
			presentTimes+=("${i}")
		done

		# Sort these times
		presentTimesSorted=($(sort <<<"${presentTimes[*]}"))

		dayName=$(date --date="$x" +"%A")
		echo "## $dayName" >> ~/Programs/output/.temp/schedule.md

		for timeA in "${presentTimesSorted[@]}"; do
			#echo "### $timeA" >> ~/Programs/output/.temp/schedule.md
			for entryB in "${curDates[@]}"; do
				if [[ "$entryB" == *"$timeA"* ]]; then
					itemA=$(echo "$entryB" | cut -d\, -f3)
					echo "* \`$timeA\` - $itemA" >> ~/Programs/output/.temp/schedule.md
				fi
			done
			#echo "⁣" >> ~/Programs/output/.temp/schedule.md
		done
	#sed -i '$ d' ~/Programs/output/.temp/schedule.md
	done

	glow unbuffer ~/Programs/output/.temp/schedule.md
}

addEntry () {
	fileName=$(getFileName $1)
	echo $1,$2,$3 >> $fileName
}

getDateFromDay () {
	curDate=$(date +"%y%m%d")

	curDay=$(date +"%w")

	curDay=$((curDay-1))

	startOfWeekA=$((curDate-curDay))
	startOfWeek=$(date --date=$startOfWeekA)

	if [[ "$1" == "mon" ]]; then
		echo $(date -d $startOfWeekA+0days +"%y%m%d")
	elif [[ "$1" == "tue" ]]; then
		echo $(date -d $startOfWeekA+1days +"%y%m%d")
	elif [[ "$1" == "wed" ]]; then
		echo $(date -d $startOfWeekA+2days +"%y%m%d")
	elif [[ "$1" == "thu" ]]; then
		echo $(date -d $startOfWeekA+3days +"%y%m%d")
	elif [[ "$1" == "fri" ]]; then
		echo $(date -d $startOfWeekA+4days +"%y%m%d")
	elif [[ "$1" == "sat" ]]; then
		echo $(date -d $startOfWeekA+5days +"%y%m%d")
	elif [[ "$1" == "sun" ]]; then
		echo $(date -d $startOfWeekA+6days +"%y%m%d")
	elif [[ "$1" == "t" ]]; then
		echo $(date -d $2+0days +"%y%m%d")
	elif [[ "$1" == "tt" ]]; then
		echo $(date -d $2+1days +"%y%m%d")
	fi
}

if [[ "$1" == "-c" ]]; then
	getDateFromDay $2
elif [[ "$1" == "-a" ]]; then
	if ! [[ "$#" == 4 ]]; then
		echo "Wrong number of arguments"
		echo "Correct format: schedule -a yymmdd hhmm STRING"
		exit
	fi
	if ! [[ "$2" =~ ^[0-9]+$ ]]; then
		arg1=$(getDateFromDay $2)
		addEntry $arg1 $3 $4
	elif ! [[ "${#2}" == "6" ]]; then
		echo "Wrong format for date"
		echo "Correct format: schedule -a yymmdd hhmm STRING"
	elif ! [[ "${#3}" == "4" ]]; then
		echo "Wrong format for date"
		echo "Correct format: schedule -a yymmdd hhmm STRING"
	else
		addEntry $2 $3 $4
	fi
else
	printSchedule $(getFileName $1)
fi
