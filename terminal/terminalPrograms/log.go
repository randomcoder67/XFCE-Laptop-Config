package main
import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"time"
	"strconv"
	"bufio"
	"strings"
)

const LOG_DIR string = "/Programs/output/log/" // The directory where the log JSON files are stored
var HOME_DIR string

var keyToFullName = map[string]string {
	"stuff": "What Happened",
	"trips": "Where Was I",
	"video": "Favourite Video",
	"song": "Favourite Song",
	"learn": "What Did I Learn",
}

func getJSON(fileName string) map[string]interface{} {
	//fmt.Println(fileName)
	dat, err := os.ReadFile(HOME_DIR + LOG_DIR + fileName)
	if err != nil {
		dat = []byte("{}")
	}
	// Decode JSON
	bytesFile := dat
	var curJSON map[string]interface{}
	if err := json.Unmarshal(bytesFile, &curJSON); err != nil {
		panic(err)
	}
	return curJSON
}

func getDateParts(previousDay bool) (string, string, string) {
	var dt time.Time
	if time.Now().Hour() < 17 {
		dt = time.Now().AddDate(0, 0, -1) // Get yesterdays date if time is before 1700 
	} else {
		dt = time.Now()
	}
	if previousDay {
		dt = dt.AddDate(0, 0, -1)
	}
	fmt.Printf("Adding entry for: %s\n", dt.Format("Monday, 02 Jan 2006"))
	
	// Get day 
	day := int(dt.Day())
	var dayString string
	if day < 10 {
		dayString = "0" + strconv.Itoa(day)
	} else {
		dayString = strconv.Itoa(day)
	}
	// Get month 
	month := int(dt.Month())
	var monthString string
	if month < 10 {
		monthString = "0" + strconv.Itoa(month)
	} else {
		monthString = strconv.Itoa(month)
	}
	// Get year 
	year := dt.Year() - 2000
	
	return dayString, monthString, strconv.Itoa(year)
}

// Add a new entry for today (or yesterday if before 1700)
func newEntry(previousDay bool) {
	dayString, monthString, yearString := getDateParts(previousDay)
	
	// Put month and year together into filename 
	fileName := yearString + monthString + ".json"
	
	// Read file 
	curJSON := getJSON(fileName)
	
	// Get user input 
	fmt.Println("What Happened Today: ")
	in := bufio.NewReader(os.Stdin)
	stuff, err := in.ReadString('\n')
	
	fmt.Println("Where Were You Today: ")
	in = bufio.NewReader(os.Stdin)
	trips, err := in.ReadString('\n')
	
	fmt.Println("Favourite Video Today: ")
	in = bufio.NewReader(os.Stdin)
	video, err := in.ReadString('\n')
	
	fmt.Println("Favourite Song Today: ")
	in = bufio.NewReader(os.Stdin)
	song, err := in.ReadString('\n')
	
	fmt.Println("What Did You Learn Today: ")
	in = bufio.NewReader(os.Stdin)
	learn, err := in.ReadString('\n')
	
	// Strip trailing newline
	stuff = strings.ReplaceAll(stuff, "\n", "")
	trips = strings.ReplaceAll(trips, "\n", "")
	video = strings.ReplaceAll(video, "\n", "")
	song = strings.ReplaceAll(song, "\n", "")
	learn = strings.ReplaceAll(learn, "\n", "")
	
	// Create new map representing the day and add to the overall map
	var toAdd = map[string]string{"stuff": stuff, "trips": trips, "video": video, "song": song, "learn": learn}
	curJSON[dayString] = toAdd
	// Resave to file with indents 
	newData, err := json.MarshalIndent(curJSON, "", "  ");
	if err != nil {
		panic(err)
	}
	err = os.WriteFile(HOME_DIR + LOG_DIR + fileName, newData, 0666)
	if err != nil {
		panic(err)
	}
}

// Function to get only files matching a certain year or month 
func filterFiles(month bool, toFilter string) []string {
	stringSlice := 2 // Focus only on year (first 2 characters) unless the month bool is true 
	if month {
		stringSlice = 4
	}
	files, err := ioutil.ReadDir(HOME_DIR + LOG_DIR) // Get all files 
	if err != nil {
		panic(err)
	}
	filesToUse := []string{} // Make empty slice 
	for _, file := range files {
		if toFilter == file.Name()[0:stringSlice] && !strings.Contains(file.Name(), "Dreams") { // Filter files 
			filesToUse = append(filesToUse, file.Name())
		}
	}
	return filesToUse // Returned filtered list (slice)
}

// Function to find favourite songs 
func findFavSongs(doTrim bool, year string) {
	filesToUse := filterFiles(false, year) // Get only files from the desired year 
	var allSongs = make(map[string]int)
	
	for _, file := range filesToUse { // Iterate through files in list 
		curJSON := getJSON(file)
		for _, v := range curJSON { // Iterate through days in file 
			curSong := (v.(map[string]interface{})["song"]).(string) // Get current song 
			if curSong != "N/A" { // Check the song is not null 
				if allSongs[curSong] == 0 { // Check if it is already in the map 
					allSongs[curSong] = 1 // If not, add it
				} else {
					var tempNum int = allSongs[curSong] + 1 // If it is there, add one to count 
					allSongs[curSong] = tempNum
				}
			}
		}
	}
	
	keys := make([]string, 0, len(allSongs)) // Make slice to hold all the songs
	for key := range allSongs { // Add all the songs 
		keys = append(keys, key)
	}
	
	sort.SliceStable(keys, func(i, j int) bool{ // Sort keys alphabetically 
		return keys[i] < keys[j]
	})
	
	sort.SliceStable(keys, func(i, j int) bool{ // Sort keys by number of entries 
		return allSongs[keys[i]] > allSongs[keys[j]]
	})
	
	for i := 0; i < len(keys); i++ {
		if doTrim { // If option was -f
			if allSongs[keys[i]] > 1 { // Only prints songs with 2 or more entries 
				fmt.Printf("%d: %s (%d)\n", i+1, keys[i], allSongs[keys[i]])
			}
		} else { // If the option was -fa, prints every song 
			fmt.Printf("%d: %s (%d)\n", i+1, keys[i], allSongs[keys[i]])
		}
	}
}

// Function to perform search on a specific month 
func searchMonth(month string, toSearchA string) bool {
	fileName := month + ".json"
	curJSON := getJSON(fileName)
	dreamsJSON := getJSON(month + "Dreams.json")
	
	//daysFound := make(map[string]struct{}) // Make empty map (essentially a set) for matching days 
	
	var notYetPrintedMonth bool = true
	
	for day, content := range curJSON { // Iterate through days
		var notYetPrintedDay bool = true
		for key, entry := range content.(map[string]interface{}) { // Iterate through categories 
			// Check for match (case insensitive)
			if strings.Contains(strings.ToLower(entry.(string)), strings.ToLower(toSearchA)) {
				if notYetPrintedMonth { // If in a new month, print the month
					fmt.Println("Present in month: " + month)
					notYetPrintedMonth = false
				}
				if notYetPrintedDay { // If in a new day, print the day 
					fmt.Println(day + ":")
					notYetPrintedDay = false
				}
				fmt.Println(keyToFullName[key] + ": " + entry.(string)) // Print the key and matching value 
				//daysFound[day] = struct{}{}
			}
		}
		if dreamsJSON[day] != nil {
			var dream string = dreamsJSON[day].(map[string]interface{})["dream"].(string)
			if strings.Contains(strings.ToLower(dream), strings.ToLower(toSearchA)) {
				if notYetPrintedMonth { // If in a new month, print the month
					fmt.Println("Present in month: " + month)
					notYetPrintedMonth = false
				}
				if notYetPrintedDay { // If in a new day, print the day 
					fmt.Println(day + ":")
					notYetPrintedDay = false
				}
				fmt.Println("Dreams: " + dream) // Print the key and matching value 
			}
		}
	}
	return !notYetPrintedMonth
	
	/*
	days := make([]string, 0) // Make slice to hold matching days 
	for day, _ := range daysFound { // Add days to slice 
		days = append(days, day)
	}
	
	sort.SliceStable(days, func(i, j int) bool{ // Sort slice 
		return days[i] < days[j]
	})
	
	if len(days) > 0 { // As long as the slice isn't empty, print the month and days 
		fmt.Println("Present in month: " + month)
		for _, day := range days {
			fmt.Println(day)
		}
	}
	*/
}

// Search function, calls searchMonth as needed 
func search(date string, toSearch string) {
	if len(date) == 4 { // If a year and month specified, call searchMonth once 
		searchMonth(date, toSearch)
	} else if len(date) == 2 { // Else get all files in specified year and run searchMonth for each of them 
		filesToUse := filterFiles(false, date)
		for i := range filesToUse {
			// Search months
			if searchMonth(filesToUse[i][0:4], toSearch) && i < len(filesToUse)-1 {
				fmt.Printf("\n") // Print newline only if a match was found and not the last month
				// BUG: If last match is in second last month, will still print newline
			}
		}
	}
}

// Function to get data from a given day 
func getDay(date string) {
	year := date[0:2]
	month := date[2:4]
	day := date[4:6]
	
	fileName := year + month + ".json"
	curJSON := getJSON(fileName)
	// Print the 5 pieces of information correctly formatted 
	requestedDay := curJSON[day]
	if requestedDay == nil { // Check if day doesn't exist
		fmt.Println("Day not present")
		os.Exit(0)
	}
	dreamsJSON := getJSON(year + month + "Dreams.json")
	fmt.Printf("What Happened:    %s\n", requestedDay.(map[string]interface{})["stuff"].(string))
	fmt.Printf("Where Were You:   %s\n", requestedDay.(map[string]interface{})["trips"].(string))
	fmt.Printf("Favourite Video:  %s\n", requestedDay.(map[string]interface{})["video"].(string))
	fmt.Printf("Favourite Song:   %s\n", requestedDay.(map[string]interface{})["song"].(string))
	fmt.Printf("Learned:          %s\n", requestedDay.(map[string]interface{})["learn"].(string))
	if len(dreamsJSON) > 0 {
		requestedDayDreams, ok := dreamsJSON[day]
		if ok {
			fmt.Printf("Dreams:           %s\n", requestedDayDreams.(map[string]interface{})["dream"].(string))
		} else {
			fmt.Printf("Dreams:           No Entry\n")
		}
	} else {
		fmt.Printf("Dreams:           No Entry\n")
	}
}

func getFilledDays(month string) {
	fileName := month + ".json"
	curJSON := getJSON(fileName)
	// https://stackoverflow.com/questions/21362950/getting-a-slice-of-keys-from-a-map
	keys := make([]string, len(curJSON))
	i := 0
	for k := range curJSON {
		keys[i] = k
		i++
	}
	
	sort.SliceStable(keys, func(i, j int) bool{ // Sort keys alphabetically 
		return keys[i] < keys[j]
	})
	for i=0; i<len(keys); i++ {
		fmt.Println(keys[i])
	}
}

func addDream(previousDay bool) {
	dayString, monthString, yearString := getDateParts(previousDay)
	
	// Put month and year together into filename 
	fileName := yearString + monthString + "Dreams.json"
	_ = dayString
	
	// Read file 
	dreamJSON := getJSON(fileName)
	
	fmt.Println("Dream Last Night: ")
	in := bufio.NewReader(os.Stdin)
	dream, err := in.ReadString('\n')
	
	// Strip trailing newline
	dream = strings.ReplaceAll(dream, "\n", "")
	
	// Create new map representing the day and add to the overall map
	var toAdd = map[string]string{"dream": dream}
	dreamJSON[dayString] = toAdd
	// Resave to file with indents 
	newData, err := json.MarshalIndent(dreamJSON, "", "  ");
	if err != nil {
		panic(err)
	}
	err = os.WriteFile(HOME_DIR + LOG_DIR + fileName, newData, 0666)
	if err != nil {
		panic(err)
	}
}

func printHelp() {
	fmt.Println("Usage:\n  log - Add New Entry\n  -p Add New Entry (Previous Day)\n  -d yymmdd - Get Information For Date\n  -ds (mm/yymm) - Get Avalible Dates\n  -s yy/yymm string - Search Month/Year for string\n  -f - Get Favourite Song (only entries with 2 or more days)\n  -fa - Get Favourite Songs (all)")
}

func main() {
	// Get current year to pass to some functions 
	currentYear := time.Now().Year() - 2000
	HOME_DIR, _ = os.UserHomeDir()
	// Parse command line arguments 
	if len(os.Args) > 1 {
		arg := os.Args[1]
		if arg == "-s" { // Search function 
			if len(os.Args) == 4 {
				search(os.Args[2], os.Args[3])
			} else {
				fmt.Println("Usage: log -s yy/yymm string")
			}
		} else if arg == "-d" { // Get info about a specific day 
			if len(os.Args) == 3 {
				getDay(os.Args[2])
			} else {
				fmt.Println("Usage: log -d yymmdd")
			}
		} else if arg == "-ds" { // Show all filled days in given month
			if len(os.Args) == 3 {
				var currentMonthString string = os.Args[2]
				if len(os.Args[2]) < 3 {
					if len(os.Args[2]) == 1 {
						currentMonthString = "0" + currentMonthString
					}
					currentMonthString = strconv.Itoa(currentYear) + currentMonthString
				}
				getFilledDays(currentMonthString)
			} else {
				currentMonth := time.Now().Month()
				var currentMonthString string = strconv.Itoa(int(currentMonth))
				if int(currentMonth) < 10 {
					currentMonthString = "0" + currentMonthString
				}
				currentMonthString = strconv.Itoa(currentYear) + currentMonthString
				getFilledDays(currentMonthString)
			}
		} else if arg == "-f" { // Find favourite songs (only 2 or more entries)
			if len(os.Args) == 2 {
				findFavSongs(true, strconv.Itoa(currentYear))
			} else if len(os.Args) == 3 {
				findFavSongs(true, os.Args[2])
			} else {
				fmt.Println("Usage: log -f/fa (year)")
			}
		} else if arg == "-fa" { // Find favourite songs (all)
			if len(os.Args) == 2 {
				findFavSongs(false, strconv.Itoa(currentYear))
			} else if len(os.Args) == 3 {
				findFavSongs(false, os.Args[2])
			} else {
				fmt.Println("Usage: log -f/fa (year)")
			}
		} else if arg == "-h" { // Display help
			printHelp()
		} else if arg == "-p" {
			newEntry(true)
		} else if arg == "-da" {
			if len(os.Args) == 3 && os.Args[2] == "-p" {
				addDream(true)
			} else {
				addDream(false)
			}
		} else {
			printHelp()
			os.Exit(1)
		}
	} else { // If no arguments, add new entry
		newEntry(false)
	}
}
