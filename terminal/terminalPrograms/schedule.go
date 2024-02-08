package main

import (
	"fmt"
	"encoding/csv"
	"os"
	"strings"
	"time"
	"strconv"
	"sort"
	"io/fs"
	"bytes"
	"math"
)

const THEME_PATH string = "/Programs/output/updated/currentTheme.txt"
const BASE_PATH string = "/Programs/output/schedule/"
const TEMP_PATH string = "/Programs/output/.temp/"
const TIME_COLOUR string = "\033[35m\033[48;2;48;48;48m"
const DAY_COLOUR_RAILSCASTS string = "\033[38;2;221;136;83m\033[1m"
const DAY_COLOUR_DRACULA string = "\033[38;2;252;200;127m\033[1m"
const HEADER_COLOUR string = "\033[31m\033[1m"
const WEEK_NAME_COLOUR string = "\033[33m\033[1m"
const RESET_COLOUR string = "\033[0m"

var DAY_COLOUR string
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

var validDates = []string{"mon", "tue", "wed", "thu", "fri", "sat", "sun", "nmon", "ntue", "nwed", "nthu", "nfri", "nsat", "nsun", "t", "tm"}

func stringInArray(toMatch string, arrayA []string) bool {
	for _, b := range arrayA {
		if b == toMatch {
			return true
		}
	}
	return false
}

func getFileContents(fileName string) string {
	dat, err := os.ReadFile(fileName)
	if err != nil {
		if _, ok := err.(*fs.PathError); !ok {
			panic(err)
		}
	}
	if dat == nil {
		return ""
	}
	return string(dat)
}

func getYearWeek(date string, ahead int) string { // Get year and week in format yyww
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
		if ahead != 0 {
			daysToAdd = 7 * ahead
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
func convertDayToDate(day string, ahead int) string {
	var dtFinal time.Time
	// As well as mon-sun, t and tm, nmon is also valid, meaning next monday 
	// If the first letter of day is n, add on 7 to get next week
	var toAdd int = 0
	if string(day[0]) == "n" {
		toAdd = 7
		day = day[1:4] // Remove leading n from day variable 
	}
	if ahead != 0 {
		toAdd = 7 * ahead
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
			curDay = 6
		}
		dtFinal = time.Now().AddDate(0, 0, (dayToNum[day]-curDay+toAdd))
	}
	
	// Format string to return (yymmdd)
	return dtFinal.Format("060102")
}

func convertToMetric(givenTime string) string {
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
	
	// Return metric time
	return fmt.Sprintf("%02d%02d", metricHours, metricMinutes)
}

func addEntry(time string, date string, description string, internal bool) {
	fileName := homeDir + BASE_PATH + getYearWeek(date, 0) + ".csv"
	fileContents := getFileContents(fileName)
	if len(date) != 6 {
		if stringInArray(date, validDates) {
			date = convertDayToDate(date, 0)
		} else {
			fmt.Println("Error, incorrectly formatted date")
			fmt.Printf("Usage: \n  schedule -a hhmm yymmdd/day description to add\n")
			os.Exit(1)
		}
	}
	
	// Format description properly
	description = strings.ReplaceAll(description, "\"", "'")
	description = strings.ReplaceAll(description, "|", " ")
	if len(description) > 37 {
		description = description[:34] + "..."
	}
	
	var internalString string = "e"
	if internal {
		internalString = "i"
	}
	// Add new entry and write to file
	fileContents = fileContents + date + "|" + time + "|" + description + "|" + internalString + "\n"
	err := os.WriteFile(fileName, []byte(fileContents), 0666)
	if err != nil {
		panic(err)
	}
}

func addMultipleEntry(givenTime string, date string, description string, repeat string, internal bool) {
	// Create slice to add required weeks to
	var weeksToAdd = []int{}
	// Split repeat at commas to get weeks
	splitRepeat := strings.Split(repeat, ",")
	for _, x := range splitRepeat {
		if strings.Contains(x, "-") { // If of the form x-y, add number x to y inclusive
			xSplit := strings.Split(x, "-")
			start, _ := strconv.Atoi(xSplit[0])
			end, _ := strconv.Atoi(xSplit[1])
			for i:=start; i<end+1; i++ {
				weeksToAdd = append(weeksToAdd, i)
			}
		} else { // Otherwise just add number
			xInt, _ := strconv.Atoi(x)
			weeksToAdd = append(weeksToAdd, xInt)
		}
	}
	
	// Get the given date as a time object
	var givenDate string
	if len(date) == 6 {
		givenDate = date
	} else {
		givenDate = convertDayToDate(date, 0)
	}
	givenDateObject, _ := time.Parse("060102", givenDate)
	
	// Iterate through weeksToAdd
	for _, toAdd := range weeksToAdd {
		dateToAdd := givenDateObject.AddDate(0, 0, 7*toAdd) // Get the date by week offset (0 is this week)
		addEntry(givenTime, dateToAdd.Format("060102"), description, internal) // Add the entry
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

func viewSchedule(toAdd int, internal bool, metricTime bool) {
	var fileName string
	var middleOfWeek string // Middle of week is to allow the output to split over two columns 
	if toAdd != 0 { // If nextWeek is true, print next weeks schedule, not this weeks
		fileName = homeDir + BASE_PATH + getYearWeek("nmon", toAdd) + ".csv"
		middleOfWeek = convertDayToDate("nthu", toAdd)
	} else {
		fileName = homeDir + BASE_PATH + getYearWeek("t", 0) + ".csv"
		middleOfWeek = convertDayToDate("thu", 0)
	}
	
	// Read in csv file with delimiter of "|"
	r := csv.NewReader(strings.NewReader(getFileContents(fileName)))
	r.Comma = '|'
	records, _ := r.ReadAll()
	
	// Get week name, if present
	fileName = homeDir + BASE_PATH + "Names" + fileName[len(fileName)-8:len(fileName)-6] + ".csv"
	r2 := csv.NewReader(strings.NewReader(getFileContents(fileName)))
	r2.Comma = '|'
	names, _ := r2.ReadAll()
	var startOfWeek string = getStartOfWeek(middleOfWeek)
	var weekName string = ""
	for _, item := range names {
		if item[0] == startOfWeek {
			weekName = item[1]
		}
	}
	
	
	// If internal entries not requested, filter them out
	if !internal {
		tempRecords := [][]string{}
		for _, entry := range records {
			if entry[3] == "e" {
				tempRecords = append(tempRecords, entry)
			}
		}
		// Remake records to be the len of tempRecords
		records = make([][]string, len(tempRecords))
		// Copy tempRecords to records
		copy(records, tempRecords)
	}
	
	// Check if records are nil
	if records == nil || len(records) == 0 {
		// Format error message properly
		var whichWeekString string = "this"
		if toAdd == 1 {
			whichWeekString = "next"
		} else if toAdd > 1 {
			whichWeekString = "that"
		}
		fmt.Printf("No entries in schedule for %s week\n", whichWeekString)
		os.Exit(0)
	}
	
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
	printSchedule(markdownSlices[0], markdownSlices[1], weekName, metricTime)
}


func printSchedule(columnA [][]string, columnB [][]string, weekName string, metricTime bool) {
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
	var weekNamePadding int = 36 + 5
	weekNamePadding = weekNamePadding - (len(weekName)/2)
	fmt.Printf(strings.Repeat(" ", weekNamePadding) + WEEK_NAME_COLOUR + weekName + RESET_COLOUR + "\n")
	for i:=0; i<lenA; i++ {
		var toPrintA string
		var toPrintB string
		var timeStringA string = columnA[i][0]
		var timeStringB string = columnB[i][0]
		if metricTime {
			if len(columnA[i]) == 2 {
				timeStringA = convertToMetric(columnA[i][0])
			}
			if len(columnB[i]) == 2 {
				timeStringB = convertToMetric(columnB[i][0])
			}
		}
		
		if len(columnA[i]) == 2 {
			toPrintA = "  " + TIME_COLOUR + " " + timeStringA + " " + RESET_COLOUR + columnA[i][1]
		} else {
			toPrintA = DAY_COLOUR + columnA[i][0] + RESET_COLOUR
		}
		
		if len(columnB[i]) == 2 {
			toPrintB = "  " + TIME_COLOUR + " " + timeStringB + " " + RESET_COLOUR + columnB[i][1]
		} else {
			toPrintB = DAY_COLOUR + columnB[i][0] + RESET_COLOUR
		}
		
		fmt.Printf("%s%s\n", toPrintA, toPrintB)
	}
}

// Delete an entry from the schedule
func deleteEntry(time string, date string) {
	fileName := homeDir + BASE_PATH + getYearWeek(date, 0) + ".csv"
	if len(date) != 6 {
		if stringInArray(date, validDates) {
			date = convertDayToDate(date, 0)
		} else {
			fmt.Println("Error, incorrectly formatted date")
			fmt.Printf("Usage: \n  schedule -d hhmm yymmdd/day\n")
			os.Exit(1)
		}
	}
	
	// Read in csv file with delimiter of "|"
	r := csv.NewReader(strings.NewReader(getFileContents(fileName)))
	r.Comma = '|'
	records, _ := r.ReadAll()
	
	// Make new slice to hold updated records
	newRecords := [][]string{}
	
	// Iterate through records and only add non-matching items to newRecords
	for _, entry := range records {
		if entry[0] != date || entry[1] != time {
			newRecords = append(newRecords, entry)
		}
	}
	
	// Save back to file
	toWrite := new(bytes.Buffer)
	w := csv.NewWriter(toWrite)
	// "|" as delimiter
	w.Comma = '|'
	if err := w.WriteAll(newRecords); err != nil {
			panic(err)
	}
	w.Flush()
	// Write to file
	err := os.WriteFile(fileName, []byte(toWrite.String()), 0666)
	if err != nil {
		panic(err)
	}
}

func printHelp() {
	fmt.Printf("Usage: \n")
	fmt.Printf("To View:\n  schedule [-n] [x] [-i] [-m] (-n for next week, x for x weeks ahead) (-i to show interal entries) (-mt for metric time)\n")
	fmt.Printf("To Add:\n  schedule -a hhmm yymmdd/day description [0-3,5] [-i]\n  Where day is:\n  mon-sun = this week\n  nmon-nsun = next week\n  t = today\n  tm = tomorrow\n  0-3,5 = add for weeks 0-3 and 5 (where 0 is this week)\n  -i for internal\n")
	fmt.Printf("To Remove:\n  schedule -d hhmm yymmdd/day\n")
	fmt.Printf("To Name Week: \n  schedule -m yymmdd/day name [0-3,5]\n")
}

// Error out if wrong arguments given
func errorOut() {
	fmt.Printf("Error, wrongly formatted arguments\n")
	printHelp()
	os.Exit(1)
}

// Function to parse args
func parseArgs(args []string) {
	var internal bool = false
	var metricTime bool = false
	// If only one arg, then just show schedule normally
	if len(args) == 1 {
		viewSchedule(0, false, false)
		return
	}
	// If first arg is -i or -n, parse viewing options
	if args[1] == "-i" || args[1] == "-n" || args[1] == "-mt" {
		var toAdd int = 0
		for i:=1; i<len(args); {
			if args[i] == "-i" { // -i means the user wants to see internal records
				internal = true
				i++
			} else if args[i] == "-n" { // -n means next week, or x week if "-n x"
				toAdd = 1
				i++
				if len(args) > i && args[i] != "-i" && args[i] != "-mt" { // Check for x, making sure it's not -i
					var err error
					toAdd, err = strconv.Atoi(args[i])
					if err != nil {
						errorOut()
					}
					i++
				}
			} else if args[i] == "-mt" {
				metricTime = true
				i++
			} else {
				errorOut()
			}
		}
		// View schedule with given options
		viewSchedule(toAdd, internal, metricTime)
	} else if args[1] == "-d" { // If first arg is -d, deleteEntry
		if len(args) != 4 {
			errorOut()
		}
		deleteEntry(os.Args[2], os.Args[3])
	} else if args[1] == "-h" { // If first arg is -h, show help
		printHelp()
	} else if args[1] == "-a" { // If first arg is -a, parse adding options
		if len(args) < 5 {
			errorOut()
		}
		var inputTime string = args[2] // time, date and description mandatory
		var inputDate string = args[3]
		var inputDescription string = args[4]
		var weekSpan string = "" // Week span optional, initialise here
		for i:=5; i<len(args); { // Parse optional arguments
			if args[i] == "-i" { // -i means add as internal
				internal = true
				i++
			} else { // Otherwise, assume the argument is week span
				weekSpan = args[i]
				i++
			}
		}
		// Check if week span is entry and either add multiple or add one entry with given arguments
		if weekSpan != "" {
			addMultipleEntry(inputTime, inputDate, inputDescription, weekSpan, internal)
		} else {
			addEntry(inputTime, inputDate, inputDescription, internal)
		}
	} else if args[1] == "-m" {
		if len(args) < 4 {
			errorOut()
		}
		var inputDate string = args[2]
		var inputName string = args[3]
		var weekSpan string = "" // Week span optional, initialise here
		for i:=4; i<len(args); { // Parse optional arguments
			weekSpan = args[i]
			i++
		}
		// Check if week span is entry and either add multiple or add one entry with given arguments
		if weekSpan != "" {
			addMultipleName(inputDate, inputName, weekSpan)
		} else {
			addName(inputDate, inputName)
		}
	} else {
		errorOut()
	}
}

func getStartOfWeek(date string) string {
	givenDate, _ := time.Parse("060102", date)
	var curDay int = int(givenDate.Weekday()) - 1
	if curDay == -1 {
		curDay = 6
	}
	dtFinal := givenDate.AddDate(0, 0, 0-curDay)
	return dtFinal.Format("060102")
}

func addName(date string, name string) {
	fileName := homeDir + BASE_PATH + "Names" + getYearWeek(date, 0)[:2] + ".csv"
	fileContents := getFileContents(fileName)
	if len(date) != 6 {
		if stringInArray(date, validDates) {
			date = convertDayToDate(date, 0)
		} else {
			fmt.Println("Error, incorrectly formatted date")
			fmt.Printf("Usage: \n  schedule -a hhmm yymmdd/day description to add\n")
			os.Exit(1)
		}
	}
	
	// Format name properly
	name = strings.ReplaceAll(name, "\"", "'")
	name = strings.ReplaceAll(name, "|", " ")
	if len(name) > 37 {
		name = name[:34] + "..."
	}
	
	// Get start of week
	date = getStartOfWeek(date)
	
	// Add new name and write to file
	fileContents = fileContents + date + "|" + name + "\n"
	err := os.WriteFile(fileName, []byte(fileContents), 0666)
	if err != nil {
		panic(err)
	}
}

func addMultipleName(date string, name string, repeat string) {
	// Create slice to add required weeks to
	var weeksToAdd = []int{}
	// Split repeat at commas to get weeks
	splitRepeat := strings.Split(repeat, ",")
	for _, x := range splitRepeat {
		if strings.Contains(x, "-") { // If of the form x-y, add number x to y inclusive
			xSplit := strings.Split(x, "-")
			start, _ := strconv.Atoi(xSplit[0])
			end, _ := strconv.Atoi(xSplit[1])
			for i:=start; i<end+1; i++ {
				weeksToAdd = append(weeksToAdd, i)
			}
		} else { // Otherwise just add number
			xInt, _ := strconv.Atoi(x)
			weeksToAdd = append(weeksToAdd, xInt)
		}
	}
	
	// Get the given date as a time object
	var givenDate string
	if len(date) == 6 {
		givenDate = date
	} else {
		givenDate = convertDayToDate(date, 0)
	}
	givenDateObject, _ := time.Parse("060102", givenDate)
	
	// Iterate through weeksToAdd
	for _, toAdd := range weeksToAdd {
		dateToAdd := givenDateObject.AddDate(0, 0, 7*toAdd) // Get the date by week offset (0 is this week)
		addName(dateToAdd.Format("060102"), name) // Add the entry
	}
}

func main() {
	homeDir, _ = os.UserHomeDir()
	// Read in theme and set colours accordingly
	dat, _ := os.ReadFile(homeDir + THEME_PATH)
	var themeName string = string(dat)
	themeName = strings.TrimSuffix(themeName, "\n")
	if themeName == "railscasts" {
		DAY_COLOUR = DAY_COLOUR_RAILSCASTS
	} else if themeName == "dracula" {
		DAY_COLOUR = DAY_COLOUR_DRACULA
	}
	
	parseArgs(os.Args)
}
