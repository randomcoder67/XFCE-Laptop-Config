package main

import (
	"fmt"
	"os"
	"bufio"
	"strings"
	"time"
	"encoding/csv"
	"sort"
)


const BASE_PATH string = "/Programs/output/money/"
const PRICE_COLOUR string = "\033[34m\033[1m"
const DATE_COLOUR string = "\033[38;2;221;136;83m"
const HEADER_COLOUR string = "\033[36m\033[1m"
const RESET_COLOUR string = "\033[0m"

var homeDir string

func getFileContents(fileName string) string {
	dat, _ := os.ReadFile(fileName)
	if dat == nil {
		return ""
	}
	return string(dat)
}

func filterEntries(mainString string, filterString string) string {
	// Split into lines
	toFilter := strings.Split(mainString, "\n")
	// Create final empty string 
	var finalString string = ""
	// Iterate through slice of all lines and only add the matching ones to finalString
	for i:=0; i<len(toFilter); i++ {
		if strings.Contains(strings.ToLower(toFilter[i]), strings.ToLower(filterString)) {
			finalString = finalString + toFilter[i] + "\n"
		}
	}
	return finalString
}

func viewEntries(shouldSearch bool, queryString string, dateFileCode string, sortBy string) {
	// Open file and get data 
	fileName := homeDir + BASE_PATH + dateFileCode + ".csv"
	fileContents := getFileContents(fileName)
	if fileContents == "" {
		fmt.Println("Error, month not present in records")
		os.Exit(1)
	}
	// Filter data if necessary
	if shouldSearch {
		fileContents = filterEntries(fileContents, queryString)
	}
	// Read in csv
	r := csv.NewReader(strings.NewReader(fileContents))
	r.Comma = '|'
	records, _ := r.ReadAll()
	
	// Sorting, default sort is by date then name
	var firstColumn, secondColumn int
	if sortBy == "date" {
		firstColumn = 0
		secondColumn = 1
	} else if sortBy == "name" || sortBy == "item" {
		firstColumn = 1
		secondColumn = 0
	} else if sortBy == "price" {
		firstColumn = 2
		secondColumn = 0
	} else if sortBy == "shop" || sortBy == "store" {
		firstColumn = 3
		secondColumn = 0
	}
	// Do sorting with desired columns 
	sort.SliceStable(records, func(i, j int) bool{
		return records[i][firstColumn]+records[i][secondColumn] < records[j][firstColumn]+records[j][secondColumn]
	})
	
	// Get maximum length of various columns (date is always the same, 6 digits)
	var dateMaxLength int = 6
	var itemMaxLength int = 0
	var priceMaxLength int = 0
	var shopMaxLength int = 0
	for i:=0; i<len(records); i++ {
		if len(records[i][1]) > itemMaxLength {
			itemMaxLength = len(records[i][1])
		} else if len(records[i][2]) > priceMaxLength {
			priceMaxLength = len(records[i][2])
		} else if len(records[i][3]) > shopMaxLength {
			shopMaxLength = len(records[i][3])
		}
	}
	
	// Print everything formatted correctly 
	fmt.Printf("\n")
	// Print table header
	fmt.Printf("  %s│%s│%s│%s\n", " " + HEADER_COLOUR + "Date" + RESET_COLOUR + strings.Repeat(" ", dateMaxLength-3), " " + HEADER_COLOUR + "Item" + RESET_COLOUR + strings.Repeat(" ", itemMaxLength-3), " " + HEADER_COLOUR + "Price" + RESET_COLOUR + " " + strings.Repeat(" ", priceMaxLength-4), " " + HEADER_COLOUR + "Shop" + RESET_COLOUR + strings.Repeat(" ", shopMaxLength-3))
	// Print table horizontal divider 
	fmt.Printf("  %s┼%s┼%s┼%s\n", strings.Repeat("─", dateMaxLength+2), strings.Repeat("─", itemMaxLength+2), strings.Repeat("─", priceMaxLength+3), strings.Repeat("─", shopMaxLength+2))
	// Print entries with correct amount of padding
	for i:=0; i<len(records); i++ {
		itemLength := len(records[i][1])
		dateLength := 6
		priceLength := len(records[i][2])
		shopLength := len(records[i][3])
		fmt.Printf("  %s│%s│%s│%s\n", " " + DATE_COLOUR + records[i][0] + RESET_COLOUR + strings.Repeat(" ", dateMaxLength-dateLength+1), " " + records[i][1] + strings.Repeat(" ", itemMaxLength-itemLength+1), " " + PRICE_COLOUR + records[i][2] + RESET_COLOUR + strings.Repeat(" ", priceMaxLength-priceLength+2), " " + records[i][3] + strings.Repeat(" ", shopMaxLength-shopLength+1))
	}
}

func addEntries() {
	fmt.Println("Adding Entries\n")
	// Infinite loop to add as many items as possible 
	for true {
		// Get item 
		fmt.Printf("Item: ")
		in := bufio.NewReader(os.Stdin)
		item, _ := in.ReadString('\n')
		item = strings.ReplaceAll(item, "\n", "")
		// Quit if q, quit or exit typed in item slot
		if item == "q" || item == "quit" || item == "exit" {
			break
		}
		// Get price 
		fmt.Printf("Price: ")
		in = bufio.NewReader(os.Stdin)
		price, _ := in.ReadString('\n')
		price = strings.ReplaceAll(price, "\n", "")
		// Get shop 
		fmt.Printf("Shop: ")
		in = bufio.NewReader(os.Stdin)
		shop, _ := in.ReadString('\n')
		shop = strings.ReplaceAll(shop, "\n", "")
		// Get day
		fmt.Printf("Day (blank or y or num): ")
		in = bufio.NewReader(os.Stdin)
		day, _ := in.ReadString('\n')
		day = strings.ReplaceAll(day, "\n", "")
		// Create time.Time object and get object for the given date 
		var dayObject time.Time
		if day == "" {
			dayObject = time.Now()
			day = dayObject.Format("060102")
		} else if day == "y" {
			dayObject = time.Now().AddDate(0, 0, -1)
			day = dayObject.Format("060102")
		} else {
			dayObject, _ = time.Parse("060102", day)
		}
		// Get filename code (yymm)
		var dateFileCode string = dayObject.Format("0601")
		// Form filename and get contents of file
		fileName := homeDir + BASE_PATH + dateFileCode + ".csv"
		fileContents := getFileContents(fileName)
		if fileContents == "" {
			fmt.Println("This month is not present yet in record, new file will be created")
		}
		// Add new entry
		fileContents = fileContents + day + "|" + item + "|" + price + "|" + shop + "\n"
		err := os.WriteFile(fileName, []byte(fileContents), 0666)
		if err != nil {
			panic(err)
		}
		
		fmt.Printf("\n")
	}
}

func printHelp() {
	fmt.Printf("Options:\n  -h - Show Help\n  -a - Add New Entries\n  -f string - Only Show Entries Matching String\n  -d yymm - Show Entries From Given Month (defaults to current month)\n  -s string - Sort By String (options are date, item, price, shop. Defaults to date)\n")
}

func main() {
	homeDir, _ = os.UserHomeDir()
	// Set default values for the arguments to viewEntries
	var searchString string = "blank"
	var doSearch bool = false
	var monthYear string = time.Now().Format("0601")
	var sortBy string = "name"
	// Iterate through and parse arguments 
	for i:=0; i<len(os.Args)-1; {
		if os.Args[i+1] == "-a" {
			addEntries()
			return
		} else if os.Args[i+1] == "-h" {
			printHelp()
			return
		} else if os.Args[i+1] == "-f" {
			doSearch = true
			searchString = os.Args[i+2]
			i += 2
		} else if os.Args[i+1] == "-d" {
			monthYear = os.Args[i+2]
			i += 2
		} else if os.Args[i+1] == "-s" {
			sortBy = os.Args[i+2]
			i += 2
		} else {
			i += 1
		}
	}
	viewEntries(doSearch, searchString, monthYear, sortBy)
}
