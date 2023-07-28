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
