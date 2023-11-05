#!/usr/bin/env bash

# Script to get "metric time" (i.e. time with 100 minute hours)
# Defaults to seconds as the base unit, only displaying minutes and hours

# Get current time and split into parts
curTime=$(date +"%H %M %S %N")
hours=${curTime%% *}
minutes=${curTime#* }
minutes=${minutes%% *}
seconds=${curTime#* * }
seconds=${seconds%% *}
nanoseconds=${curTime##* }
#echo "H:$hours M:$minutes S:$seconds N:$nanoseconds"

# Convert to only minutes

# Calculate metric time with minutes as base (i.e. 100 minutes per hour)
if [[ "$1" == "-m" ]]; then
	totalMinutes=$((10#$hours*60+10#$minutes))
	metricHours=$((totalMinutes/100))
	metricMinutes=$((totalMinutes-metricHours*100))
	# Print with seconds
	if [[ "$2" == "-s" ]]; then
		metricSeconds=$(echo "($seconds+($nanoseconds/1000000000))/60*100" | bc -l)
		metricSecondsInt=${metricSeconds%.*}
		printf "%02d:%02d:%02d\n" $metricHours $metricMinutes $metricSecondsInt
	# Print without seconds
	else
		printf "%02d:%02d\n" $metricHours $metricMinutes
	fi
# Calculate metric time with seconds as base (i.e. 100 seconds per minute)
elif [[ "$1" == "-s" ]]; then
	totalSeconds=$((10#$hours*3600+10#$minutes*60+10#$seconds))
	metricHours=$((totalSeconds/10000))
	metricMinutes=$(((totalSeconds-metricHours*10000)/100))
	# Print with seconds
	if [[ "$2" == "-s" ]]; then
		metricSeconds=$((totalSeconds-metricHours*10000-metricMinutes*100))
		printf "%02d:%02d:%02d\n" $metricHours $metricMinutes $metricSeconds
	# Print without seconds
	else
		printf "%02d:%02d\n" $metricHours $metricMinutes
	fi
elif [[ "$1" == "-d" ]]; then
	totalSeconds=$((10#$hours*3600+10#$minutes*60+10#$seconds))
	totalMetricSeconds=$(echo "($totalSeconds+$nanoseconds/1000000000)/86400*100000" | bc -l)
	totalMetricSeconds=${totalMetricSeconds%.*}
	metricHours=$((totalMetricSeconds/10000))
	metricMinutes=$(((totalMetricSeconds-metricHours*10000)/100))
	# Print with seconds
	if [[ "$2" == "-s" ]]; then
		metricSeconds=$((totalMetricSeconds-metricHours*10000-metricMinutes*100))
		printf "%02d:%02d:%02d\n" $metricHours $metricMinutes $metricSeconds
	# Print without seconds
	else
		printf -v finalString "%02d:%02d" $metricHours $metricMinutes
		echo "<txt> - $finalString</txt>"
		echo "<tool>Metric Time</tool>"
	fi
elif [[ "$1" == "-h" ]]; then
	echo "Script to get various possible versions of \"metric time\""
	echo "Options:"
	echo "  -m [-s] - Use minutes as base (optinally show seconds)"
	echo "  -s [-s] - Use seconds as base (optinally show seconds)"
	echo "  -d [-s] - Use full metric time (100,000 second days) (optinally show seconds)"
fi

