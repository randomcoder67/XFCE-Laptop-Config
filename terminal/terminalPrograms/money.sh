#!/usr/bin/env bash

# Script to organise money

fileLocation="~/Programs/output/money/"

convertMonthToString () {
	if [[ "$1" == "01" ]]; then
		echo "January"
		return
	elif [[ "$1" == "02" ]]; then
		echo "February"
		return
	elif [[ "$1" == "03" ]]; then
		echo "March"
		return
	elif [[ "$1" == "04" ]]; then
		echo "April"
		return
	elif [[ "$1" == "05" ]]; then
		echo "May"
		return
	elif [[ "$1" == "06" ]]; then
		echo "June"
		return
	elif [[ "$1" == "07" ]]; then
		echo "July"
		return
	elif [[ "$1" == "08" ]]; then
		echo "August"
		return
	elif [[ "$1" == "09" ]]; then
		echo "September"
		return
	elif [[ "$1" == "10" ]]; then
		echo "October"
		return
	elif [[ "$1" == "11" ]]; then
		echo "November"
		return
	elif [[ "$1" == "12" ]]; then
		echo "December"
		return
	fi
}

addEntry () {
	while true; do
		read -p "Name: " nameA
		if [[ "$nameA" == "exit" ]] || [[ "$nameA" == "q" ]]; then
			exit
		fi
		read -p "Date: " dateA
		if [[ "$dateA" == "" ]] || [[ "$dateA" == "t" ]] || [[ "$dateA" == "today" ]]; then
			dateA=$(date +"%y%m%d")
		elif [[ "$dateA" == "y" ]]; then
			dateA=$(date --date="yesterday" +"%y%m%d")
		fi
		read -p "Shop: " shopA
		read -p "Price: " priceA

		fileName="$fileLocation""money${dateA:0:4}.csv"
		echo $dateA,$nameA,$shopA,$priceA >> $fileName
	done
}



printInfo () {
	echo "# Money" > ~/Programs/output/.temp/money.md
	files=( $(find ~/Programs/output/money/ -mindepth 1 | sort) )
	for file in "${files[@]}"; do

	yearMonth=${file##~/Programs/output/money/money}
	yearMonth=${yearMonth%%.csv}

	year="20"${yearMonth:0:2}
	month=${yearMonth:2:2}

	if ! [[ "$curYear" == "$year" ]]; then
		echo "## $year" >> ~/Programs/output/.temp/money.md
	fi
	echo "### $(convertMonthToString $month) " >> ~/Programs/output/.temp/money.md
	curYear=$year
	fileName="$file"
	oldIFS=$IFS
	IFS=$'\n'
	if [[ "$1" == "-s" ]]; then
		items=( $(cat $fileName | sort | grep -i "$2") )
	elif [[ "$2" == "-s" ]]; then
		items=( $(cat $fileName | sort | grep -i "$3") )
	else
		items=( $(cat $fileName | sort) )
	fi

	echo "| Date | Item | Shop | Price |" >> ~/Programs/output/.temp/money.md
	echo "| :--: | :--: | :--: | :--: |" >> ~/Programs/output/.temp/money.md

	if [[ "$1" == "p" ]]; then
		itemsNew=("${items[@]}")
		itemsRearranged=()
		items=()
		for item in "${itemsNew[@]}"; do
			dateA=${item%%,*}
			itemA=${item#*,}
			itemA=${itemA%%,*}
			shopA=${item#*,*,}
			shopA=${shopA%,*}
			priceA=${item#*,*,*,}
			itemsRearranged+=("$priceA,$dateA,$itemA,$shopA")
		done
		items=($(sort <<<"${itemsRearranged[*]}"))
	elif [[ "$2" == "s" ]]; then
		itemsNew=("${items[@]}")
		itemsRearranged=()
		items=()
		for item in "${itemsNew[@]}"; do
			dateA=${item%%,*}
			itemA=${item#*,}
			itemA=${itemA%%,*}
			shopA=${item#*,*,}
			shopA=${shopA%,*}
			priceA=${item#*,*,*,}
			itemsRearranged+=("$shopA,$dateA,$itemA,$priceA")
		done
		items=($(sort <<<"${itemsRearranged[*]}"))
	fi

	for item in "${items[@]}"; do
		#set -f
		#IFS=','
		#item=($item)
		#echo "|${item[0]}|${item[1]}|${item[2]}|${item[3]}|" >> ~/Programs/output/.temp/money.md
		#set +f
		print1=${item%%,*}
		print2=${item#*,}
		print2=${print2%%,*}
		print3=${item#*,*,}
		print3=${print3%,*}
		print4=${item#*,*,*,}
		if [[ "$1" == "p" ]]; then
			echo "|$print2|$print3|$print4|$print1|" >> ~/Programs/output/.temp/money.md
		elif [[ "$1" == "s" ]]; then
			echo "|$print1|$print2|$print3|$print4|" >> ~/Programs/output/.temp/money.md
		else
			echo "|$print2|$print3|$print1|$print4|" >> ~/Programs/output/.temp/money.md
		fi
		IFS=$oldIFS
	done

	glow ~/Programs/output/.temp/money.md
}

if [[ "$1" == "" ]]; then
	addEntry
elif [[ "$1" == "-q" ]]; then
	printInfo $2 $3 $4
fi
