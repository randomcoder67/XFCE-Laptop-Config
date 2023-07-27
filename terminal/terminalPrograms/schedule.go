package main

import (
	"fmt"
	"encoding/csv"
	"os"
	"strings"
	"time"
	"strconv"
)

const BASE_PATH string = "/Programs/output/schedule/"
var homeDir string

func getFilename(nextWeek bool) string {
	var dt time.Time
	if nextWeek { // If next week, add 7 to current date 
		dt = time.Now().AddDate(0, 0, 7)
	} else {
		dt = time.Now()
	}
	yearInt, weekInt := dt.ISOWeek() // Get the year and week 
	yearInt = yearInt - 2000 // Convert 4 digit year to 2 digit year
	// Return formatted string (e.g. /home/user/.local/share/schedule/2318.csv)
	return homeDir + BASE_PATH + strconv.Itoa(yearInt) + strconv.Itoa(weekInt) + ".csv"
}

// Function to convert day as a string (e.g. mon, fri, t (today), tm (tomorrow)) to a usable date
func convertDayToDate(day string) string {
	dt := time.Now()
	var curDay int = int(dt.Weekday()) - 1 // Gets 0 indexed day of week 
	if curDay == 0 {
		return "Mon"
	} else if curDay == 1 {
		return "Tue"
	} else if curDay == 2 {
		return "Wed"
	} else if curDay == 3 {
		return "Thu"
	} else if curDay == 4 {
		return "Fri"
	} else if curDay == 5 {
		return "Sat"
	} else if curDay == 6 {
		return "Sun"
	}
	return "Error"
}
		

func main() {
	homeDir, _ = os.UserHomeDir()
	dat, err := os.ReadFile("input.csv")
	if err != nil {
		os.Exit(1)
	}
	
	r := csv.NewReader(strings.NewReader(string(dat)))
	records, _ := r.ReadAll()
	
	fmt.Println(records[0])
	
	fmt.Println(getFilename(false))
	fmt.Println(convertDayToDate("sun"))
}
