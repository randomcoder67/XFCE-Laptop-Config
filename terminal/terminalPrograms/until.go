package main

import (
	"fmt"
	"os"
	"encoding/csv"
	"sort"
	"strings"
	"time"
	"math"
	"bytes"
	"strconv"
)

const SAVE_LOC = "/Programs/output/updated/until.csv"
var homeDir string
var timeNow time.Time

// Open the file and return data, or return empty string if no file
func openFile(filename string) string {
	dat, err := os.ReadFile(filename)
	if err != nil {
		return ""
	}
	return string(dat)
}

// Remove any dates before today from the slice
func trimOldDates(inputSlice [][]string) [][]string {
	// Get current date in same format
	var nowString string = timeNow.Format("060102")
	// Create new slice to return and filter to only current or newer dates
	outputSlice := [][]string{}
	for _, entry := range inputSlice {
		if entry[0] >= nowString {
			outputSlice = append(outputSlice, entry)
		}
	}
	return outputSlice
}

// Write the trimmed slice back to the file, permenantly removing older dates
func updateFile(finalDaysSlice [][]string) {
	toWrite := new(bytes.Buffer)
	w := csv.NewWriter(toWrite)
	// "|" as delimiter
	w.Comma = '|'
	if err := w.WriteAll(finalDaysSlice); err != nil {
			panic(err)
	}
	w.Flush()
	// Write to file
	err := os.WriteFile(homeDir + SAVE_LOC, []byte(toWrite.String()), 0666)
	if err != nil {
		panic(err)
	}
}

// View number of days until saved dates
func viewDays(toShow int) {
	// Populate timeNow variable with current time
	timeNow = time.Now()
	// Get data from file
	daysData := openFile(homeDir + SAVE_LOC)
	if daysData == "" {
		fmt.Println("No upcoming days")
		os.Exit(0)
	}
	// Parse csv
	r := csv.NewReader(strings.NewReader(daysData))
	r.Comma = '|'
	daysSlice, _ := r.ReadAll()
	// Trim old dates
	daysSlice = trimOldDates(daysSlice)
	// Sort closest to furthest away
	sort.SliceStable(daysSlice, func(i, j int) bool{ // Sort records by date and time 
		return daysSlice[i][0]+daysSlice[i][1] < daysSlice[j][0]+daysSlice[j][1] // Combining to yymmddhhmm 
	})
	// Find longest string
	var maxStringLength int = 0
	for _, entryA := range daysSlice {
		if len(entryA[1]) > maxStringLength {
			maxStringLength = len(entryA[1])
		}
	}
	// Print nicely formatted
	for i, entry := range daysSlice {
		t, _ := time.Parse("060102", entry[0])
		var daysLeft float64 = math.Abs(math.Ceil(t.Sub(timeNow).Hours()/24))
		var daysLeftString string = strconv.FormatFloat(daysLeft,'f', 0, 64)
		var theWordDayString string = "days"
		if daysLeftString == "1" {
			theWordDayString = "day"
		}
		fmt.Printf("%s - %s%s %s from now%s(%s)\n", entry[1], strings.Repeat(" ", maxStringLength - len(entry[1]) + 2), daysLeftString, theWordDayString, strings.Repeat(" ", 10-len(theWordDayString)-len(daysLeftString)), t.Format("2006-01-02"))
		// Break if reached toShow (if toShow is 0, then this condition will never be met so 0 = all)
		if i+1 == toShow {
			break
		}
	}
	// Write final daysSlice to file
	updateFile(daysSlice)
}

// Add a new day to the file
func addDay(dateToAdd string, thingToAdd string) {
	// Check for valid arguments
	if len(dateToAdd) != 6 {
		fmt.Println("Error, incorrectly formatted arguments")
		printHelp()
		os.Exit(1)
	}
	// Add items to existing list
	fmt.Printf("Adding %s, on %s\n", thingToAdd, dateToAdd)
	daysData := openFile(homeDir + SAVE_LOC)
	daysData = daysData + dateToAdd + "|" + thingToAdd + "\n"
	// Save new list to file
	err := os.WriteFile(homeDir + SAVE_LOC, []byte(daysData), 0666)
	if err != nil {
		panic(err)
	}
}

func printHelp() {
	fmt.Printf("Usage:\n  days - To view days\n  days -s [n] - To view n days (default 10)\n  days -a yymmdd string - Add string day at yymmdd day\n")
}

func main() {
	homeDir, _ = os.UserHomeDir()
	if len(os.Args) > 1 {
		if os.Args[1] == "-a" {
			if len(os.Args) == 4 {
				addDay(os.Args[2], os.Args[3])
			} else {
				fmt.Println("Error, incorrectly formatted arguments")
				printHelp()
				os.Exit(1)
			}		   
		} else if os.Args[1] == "-h" || os.Args[1] == "--help" || os.Args[1] == "help" {
			printHelp()
			os.Exit(0)
		} else if os.Args[1] == "-s" {
			var toShow int = 10
			if len(os.Args) == 3 {
				toShow, _ = strconv.Atoi(os.Args[2])
			}
			viewDays(toShow)
		} else {
			fmt.Println("Error, invalid option")
			printHelp()
			os.Exit(1)
		}
	} else {
		viewDays(0) // 0 = all
	}
}
