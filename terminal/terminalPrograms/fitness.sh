#!/usr/bin/env bash

fileName="~/Programs/output/updated/fitness.csv"

if ! [ -f "$fileName" ]; then
	echo "date,weight,walked,bike,timeHome,timeUni,reps,mood" > "$fileName"
fi

read -p "Weight: " weightA
read -p "Walked: " walkedA
read -p "Bike: " bikeA
read -p "Time (Home): " timeHomeA
read -p "Time (Uni): " timeUniA
read -p "Reps: " repsA
read -p "Mood: " moodA

curHour=$(date +"%H")
if (( $curHour < 14 )) || ! [[ "$1" == "-t" ]]; then
	dateA=$(date --date="yesterday" +"%y%m%d")
else
	dateA=$(date +"%y%m%d")
fi

echo "$dateA,$weightA,$walkedA,$bikeA,$timeHomeA,$timeUniA,$repsA,$moodA" >> $fileName
