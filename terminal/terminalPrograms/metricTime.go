package main

import (
	"fmt"
	"time"
	"os"
	"strconv"
	"math"
)

func baseDays(showSeconds bool) {
	// Get current time and split to parts
	now := time.Now() //.Format("15:04:05.99999999")
	var hours int = now.Hour()
	var minutes int = now.Minute()
	var seconds int = now.Second()
	var nanoseconds int = now.Nanosecond()
	
	// Calculate the metric values
	var totalSeconds int = hours*3600+minutes*60+seconds
	var totalMetricSeconds int = int(math.Floor((float64(totalSeconds)+float64(nanoseconds)/1000000000)/86400*100000))
	var metricHours int = totalMetricSeconds/10000
	var metricMinutes int = (totalMetricSeconds-metricHours*10000)/100
	
	// Print metric time
	if showSeconds {
		var metricSeconds int = totalMetricSeconds-metricHours*10000-metricMinutes*100
		fmt.Printf("%02d:%02d:%02d\n", metricHours, metricMinutes, metricSeconds)
	} else {
		fmt.Printf("%02d:%02d\n", metricHours, metricMinutes)
	}
}

func baseSeconds(showSeconds bool) {
	// Get current time and split to parts
	now := time.Now() //.Format("15:04:05.99999999")
	var hours int = now.Hour()
	var minutes int = now.Minute()
	var seconds int = now.Second()
	
	// Calculate the metric values
	var totalSeconds int = hours*3600+minutes*60+seconds
	var metricHours int = totalSeconds/10000
	var metricMinutes int = (totalSeconds-metricHours*10000)/100
	
	// Print metric time
	if showSeconds {
		var metricSeconds int = totalSeconds-metricHours*10000-metricMinutes*100
		fmt.Printf("%02d:%02d:%02d\n", metricHours, metricMinutes, metricSeconds)
	} else {
		fmt.Printf("%02d:%02d\n", metricHours, metricMinutes)
	}
}

func baseMinutes(showSeconds bool) {
	// Get current time and split to parts
	now := time.Now() //.Format("15:04:05.99999999")
	var hours int = now.Hour()
	var minutes int = now.Minute()
	var seconds int = now.Second()
	var nanoseconds int = now.Nanosecond()
	
	// Calculate the metric values
	var totalMinutes int = hours*60+minutes
	var metricHours int = totalMinutes/100
	var metricMinutes int = totalMinutes-metricHours*100
	
	// Print metric time
	if showSeconds {
		var metricSeconds int = int(math.Floor((float64(seconds)+(float64(nanoseconds)/1000000000))/60*100))
		fmt.Printf("%02d:%02d:%02d\n", metricHours, metricMinutes, metricSeconds)
	} else {
		fmt.Printf("%02d:%02d\n", metricHours, metricMinutes)
	}
}

func convertToMetric(givenTime string) {
	// Add 0 if not present
	if len(givenTime) == 3 {
		givenTime = "0" + givenTime
	}
	
	// Split into hours and minutes
	hours, err := strconv.Atoi(givenTime[:2])
	if err != nil || hours > 23 {
		fmt.Println("Error, not a valid time")
		os.Exit(1)
	}
	minutes, err := strconv.Atoi(givenTime[2:])
	if err != nil || minutes > 59 {
		fmt.Println("Error, not a valid time")
		os.Exit(1)
	}
	
	// Calculate the metric values
	var totalSeconds int = hours*3600+minutes*60
	var totalMetricSeconds int = int(math.Floor(float64(totalSeconds)/86400*100000))
	var metricHours int = totalMetricSeconds/10000
	var metricMinutes int = (totalMetricSeconds-metricHours*10000)/100
	
	// Print metric time
	fmt.Printf("%02d:%02d\n", metricHours, metricMinutes)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Error")
		os.Exit(1)
	}
	if os.Args[1] == "-s" {
		if len(os.Args) == 3 && os.Args[2] == "-s" {
			baseSeconds(true)
		} else {
			baseSeconds(false)
		}
	} else if os.Args[1] == "-m" {
		if len(os.Args) == 3 && os.Args[2] == "-s" {
			baseMinutes(true)
		} else {
			baseMinutes(false)
		}
	} else if os.Args[1] == "-d" {
		if len(os.Args) == 3 && os.Args[2] == "-s" {
			baseDays(true)
		} else {
			baseDays(false)
		}
	} else if len(os.Args[1]) == 3 || len(os.Args[1]) == 4 {
		convertToMetric(os.Args[1])
	}
}
