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
const TIME_COLOUR string = "\033[35m\033[48;2;48;48;48m"
const DAY_COLOUR string = "\033[38;2;221;136;83m\033[1m"
const HEADER_COLOUR string = "\033[31m\033[1m"
const RESET_COLOUR string = "\033[0m"

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
	var middleOfWeek string // Middle of week is to allow the output to split over two columns 
	if nextWeek { // If nextWeek is true, print next weeks schedule, not this weeks
		fileName = homeDir + BASE_PATH + getYearWeek("nmon") + ".csv"
		middleOfWeek = convertDayToDate("nthu")
	} else {
		fileName = homeDir + BASE_PATH + getYearWeek("t") + ".csv"
		middleOfWeek = convertDayToDate("thu")
	}
	
	// Read in csv file with delimiter of "|"
	r := csv.NewReader(strings.NewReader(getFileContents(fileName)))
	r.Comma = '|'
	records, _ := r.ReadAll()
	
	sort.SliceStable(records, func(i, j int) bool{ // Sort records by date and time 
		return records[i][0]+records[i][1] < records[j][0]+records[j][1] // Combining to yymmddhhmm 
	})
	
	// Make array of 2 slices of slices of strings 
	// Each slice contains other slices, either of length 1 if "## Thursday 4th", or length 2 if "  14:00 Online Meeting" 
	var markdownSlices [2][][]string
	
	// Check if the first entry is past the middle of the week, and if so, put first entry into second column
	var curIndex int = 0
	if records[0][0] >= middleOfWeek {
		curIndex = 1
	}
	// Add first included day into correct column
	markdownSlices[curIndex] = append(markdownSlices[curIndex], []string{"## " + dateToDay(records[0][0])})
	for i:=0; i<len(records); i++ {
	if records[i][0] >= middleOfWeek {
		curIndex = 1
	}
		if i != 0 {
			if records[i-1][0] != records[i][0] {
				markdownSlices[curIndex] = append(markdownSlices[curIndex], []string{"## " + dateToDay(records[i][0])})
			}
		}
		markdownSlices[curIndex] = append(markdownSlices[curIndex], []string{records[i][1],": " + records[i][2]})
	}
	printSchedule(markdownSlices[0], markdownSlices[1])
}


func printSchedule(columnA [][]string, columnB [][]string) {
	// Get length of largest slice, and make the other one the same length by adding blank lines 
	columnALen := len(columnA)
	columnBLen := len(columnB)
	var lenA int
	if columnALen > columnBLen {
		lenA = columnALen
		for i:=0; i<columnALen - columnBLen; i++ {
			columnB = append(columnB, []string{strings.Repeat(" ", 36)})
		}
	} else {
		lenA = columnBLen
		for i:=0; i<columnBLen - columnALen; i++ {
			columnA = append(columnA, []string{strings.Repeat(" ", 36)})
		}
	}
	
	// Go through columnA, and if the length of the string will total less than 48, add extra spaces 
	for i:=0; i<lenA; i++ {
		if len(columnA[i]) == 2 {
			shortBy := 40 - len(columnA[i][1])
			columnA[i][1] = columnA[i][1] + strings.Repeat(" ", shortBy)
		} else {
			shortBy := 48 - len(columnA[i][0])
			columnA[i][0] = columnA[i][0] + strings.Repeat(" ", shortBy)
		}
	}
	
	// Print the schedule in the correct format
	fmt.Printf(strings.Repeat(" ", 36) + HEADER_COLOUR + "# Schedule" + RESET_COLOUR + "\n")
	for i:=0; i<lenA; i++ {
		var toPrintA string
		var toPrintB string
		if len(columnA[i]) == 2 {
			toPrintA = "  " + TIME_COLOUR + " " + columnA[i][0] + " " + RESET_COLOUR + columnA[i][1]
		} else {
			toPrintA = DAY_COLOUR + columnA[i][0] + RESET_COLOUR
		}
		
		if len(columnB[i]) == 2 {
			toPrintB = "  " + TIME_COLOUR + " " + columnB[i][0] + " " + RESET_COLOUR + columnB[i][1]
		} else {
			toPrintB = DAY_COLOUR + columnB[i][0] + RESET_COLOUR
		}
		
		fmt.Printf("%s%s\n", toPrintA, toPrintB)
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
			fmt.Printf("Usage: \n  schedule -a hhmm yymmdd/day description to add\n  Where day is:\n  mon-sun = this week\n  nmon-nsun = next week\n  t = today\n  tm = tomorrow\n")
		}
	} else {
		viewSchedule(false)
	}
}
