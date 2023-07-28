package main

import (
	"fmt"
	"encoding/csv"
	"os"
	"strings"
	"time"
	"strconv"
	"sort"
)

const BASE_PATH string = "/Programs/output/schedule/"
const TEMP_PATH string = "/Programs/output/.temp/"
var homeDir string
var dayToNum = map[string]int {
	"mon": 0,
	"tue": 1,
	"wed": 2,
	"thu": 3,
	"fri": 4,
	"sat": 5,
	"sun": 6,
}

var dateToSuffix = map[int]string {
	1: "st",
	2: "nd",
	3: "rd",
	21: "st",
	22: "nd",
	23: "rd",
	31: "st",
}

func getFileContents(fileName string) string {
	dat, err := os.ReadFile(fileName)
	if err != nil {
		fmt.Println(err)
	}
	if dat == nil {
		return ""
	}
	return string(dat)
}

func getYearWeek(date string) string { // Get year and week in format yyww
	var givenYear int
	var givenWeek int
	
	if len(date) == 6 { // If the date is yymmdd, parse it and get week 
		givenDate, _ := time.Parse("060102", date)
		givenYear, givenWeek = givenDate.ISOWeek()
	} else { // Otherwise figure out how many days ahead we are 
		var daysToAdd int
		if _, ok := dayToNum[date]; ok || date == "t" { // Today is in the current week 
			daysToAdd = 0
		} else if date == "tm" { // Tomorrow (in case current day is Sunday)
			daysToAdd = 1
		} else if string(date[0]) == "n" { // nmon-nsun is always next week 
			daysToAdd = 7
		}
		givenYear, givenWeek = time.Now().AddDate(0, 0, daysToAdd).ISOWeek()
	}
	// Correctly format string and return 
	var toReturn string = strconv.Itoa(givenYear-2000)
	if givenWeek < 10 {
		toReturn = toReturn + "0"
	}
	return toReturn + strconv.Itoa(givenWeek)
}

// Function to convert day as a string (e.g. mon, fri, t (today), tm (tomorrow)) to a usable date
func convertDayToDate(day string) string {
	var dtFinal time.Time
	// As well as mon-sun, t and tm, nmon is also valid, meaning next monday 
	// If the first letter of day is n, add on 7 to get next week
	var toAdd int = 0
	if string(day[0]) == "n" {
		toAdd = 7
		day = day[1:4] // Remove leading n from day variable 
	}
	
	// "t" = today, "tm" = tomorrow 
	if day == "t" {
		dtFinal = time.Now()
	} else if day == "tm" {
		dtFinal = time.Now().AddDate(0, 0, 1+toAdd)
	} else { // Otherwise, convert day to date by subtracting where we are in week from when day is
		dt := time.Now()
		var curDay int = int(dt.Weekday()) - 1 // Gets 0 indexed day of week 
		if curDay == -1 {
			curDay = 7
		}
		dtFinal = time.Now().AddDate(0, 0, (dayToNum[day]-curDay+toAdd))
	}
	
	// Format string to return (yymmdd)
	return dtFinal.Format("060102")
}

func addEntry(time string, date string, description string) {
	fmt.Printf("Adding: %s, %s, %s\n", time, date, description)
	fileName := homeDir + BASE_PATH + getYearWeek(date) + ".csv"
	fileContents := getFileContents(fileName)
	if len(date) != 6 {
		date = convertDayToDate(date)
	}
	
	fileContents = fileContents + date + "|" + time + "|" + description + "\n"
	
	err := os.WriteFile(fileName, []byte(fileContents), 0666)
	if err != nil {
		panic(err)
	}
}

func dateToDay(date string) string {
	givenDate, _ := time.Parse("060102", date)
	day := givenDate.Day()
	weekday := givenDate.Weekday()
	var suffix string = "th"
	suffixA, ok := dateToSuffix[day]
	if ok {
		suffix = suffixA
	}
	return weekday.String() + " " + strconv.Itoa(day) + suffix
}

func viewSchedule(nextWeek bool) {
	var fileName string
	var middleOfWeek string
	if nextWeek {
		fileName = homeDir + BASE_PATH + getYearWeek("nmon") + ".csv"
		middleOfWeek = convertDayToDate("nthu")
	} else {
		fileName = homeDir + BASE_PATH + getYearWeek("t") + ".csv"
		middleOfWeek = convertDayToDate("thu")
	}
		
	r := csv.NewReader(strings.NewReader(getFileContents(fileName)))
	r.Comma = '|'
	records, _ := r.ReadAll()
	
	sort.SliceStable(records, func(i, j int) bool{ // Sort records by date and time 
		return records[i][0]+records[i][1] < records[j][0]+records[j][1] // Combining to yymmddhhmm 
	})
	
	var markdownString = [2]string{"# Schedule\n## " + dateToDay(records[0][0]) + "\n", ""}
	var curIndex int = 0
	for i:=0; i<len(records); i++ {
	if records[i][0] >= middleOfWeek {
		curIndex = 1
	}
		if i != 0 {
			if records[i-1][0] != records[i][0] {
				markdownString[curIndex] = markdownString[curIndex] + "## " + dateToDay(records[i][0]) + "\n"
			}
		}
		markdownString[curIndex] = markdownString[curIndex] + "`" + records[i][1] + "`: " + records[i][2] + "  \n"
	}
	err1 := os.WriteFile(homeDir + TEMP_PATH +  "weekA.md", []byte(markdownString[0]), 0666)
	err2 := os.WriteFile(homeDir + TEMP_PATH +  "weekB.md", []byte(markdownString[1]), 0666)
	if err1 != nil || err2 != nil {
		os.Exit(0)
	}
}

func main() {
	homeDir, _ = os.UserHomeDir()
	
	if len(os.Args) > 1 {
		arg := os.Args[1]
		if arg == "-a" {
			addEntry(os.Args[2], os.Args[3], os.Args[4])
		} else if arg == "-n" {
			viewSchedule(true)
		} else if arg == "-h" {
			fmt.Printf("Usage: \nschedule -a hhmm yymmdd/day description to add\nWhere day is:\nmon-sun = this week\nnmon-nsun = next week\nt = today\ntm = tomorrow\n")
		}
	} else {
		viewSchedule(false)
	}
}
