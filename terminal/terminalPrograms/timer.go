package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"time"
	"os/exec" 
)

const LINE_RESET = "\033[1A"
const SOUND_EFFECT_PATH = "/Programs/output/.sounds/alarm.m4a"

var homeDir string

// Set and run the timer
func setTimer(secs int, silent bool) {
	// Print length of timer
	fmt.Printf("Setting timer for %s\n", encodeTime(secs))
	// Remaining seconds needs to be a new variable so secs can be used in for loop
	var remainingSecs int = secs
	fmt.Printf("\n")
	for i:=0; i<secs; i++ {
		// Print time remaining, reduce time remaining and sleep for a second
		fmt.Printf("%sTime Remaining: %s              \n", LINE_RESET, encodeTime(remainingSecs))
		remainingSecs--
		time.Sleep(time.Second)
	}
	fmt.Printf("Timer Completed\n")
	// If not silent, play the sound effect
	if !silent {
		soundEffectCommand := exec.Command("mpv", "--force-window=no", "--no-resume-playback", homeDir + SOUND_EFFECT_PATH)
		soundEffectCommand.Start()
	}
	// Send system notification
	notificationCommand := exec.Command("notify-send", "Timer Completed")
	notificationCommand.Start()
}

// Convert from the input time string into an int number of seconds
func decodeTime(timeString string) int {
	// Compile regex to get hours, minutes and seconds
	reHours, _ := regexp.Compile("[0-9]+h")
	reMinutes, _ := regexp.Compile("[0-9]+m")
	reSeconds, _ := regexp.Compile("[0-9]+s")
	// Get slices representing location in timeString
	hoursLoc := reHours.FindStringIndex(timeString)
	minutesLoc := reMinutes.FindStringIndex(timeString)
	secondsLoc := reSeconds.FindStringIndex(timeString)
	// Initialise variables and, if not nil, set them to present value
	var hoursTotal, minutesTotal, secondsTotal int = 0, 0, 0
	if hoursLoc == nil && minutesLoc == nil && secondsLoc == nil {
		fmt.Println("Error, incorrectly formatted arguments")
		printHelp()
		os.Exit(1)
	}
	if hoursLoc != nil {
		hoursTotal, _ = strconv.Atoi(timeString[hoursLoc[0]:hoursLoc[1]-1])
	}
	if minutesLoc != nil {
		minutesTotal, _ = strconv.Atoi(timeString[minutesLoc[0]:minutesLoc[1]-1])
	}
	if secondsLoc != nil {
		secondsTotal, _ = strconv.Atoi(timeString[secondsLoc[0]:secondsLoc[1]-1])
	}
	return secondsTotal + minutesTotal * 60 + hoursTotal * 3600
}

// Encode an int number of seconds to a nicely formatted string
func encodeTime(secs int) string {
	// Initalise variables with correct values
	var hoursTotal int = secs/3600
	var minutesTotal int = (secs-(hoursTotal*3600))/60
	var secondsTotal int = secs-(hoursTotal*3600)-(minutesTotal*60)
	// Create string to return and format it
	var toReturn string = ""
	if hoursTotal != 0 {
		toReturn = toReturn + strconv.Itoa(hoursTotal) + " Hour(s) "
	}
	if minutesTotal != 0 {
		toReturn = toReturn + strconv.Itoa(minutesTotal) + " Minute(s) "
	}
	if secondsTotal != 0 {
		toReturn = toReturn + strconv.Itoa(secondsTotal) + " Second(s) "
	}
	return toReturn
}

// Print help
func printHelp() {
	fmt.Printf("Usage:\n  timer [-s] [10h][4h][5s]\n  -s = Silent\n")
}

func main() {
	// Need at least one argument
	if len(os.Args) < 2 {
		fmt.Println("Error, incorrectly formatted arguments")
		printHelp()
		os.Exit(1)
	}
	// Print help
	if os.Args[1] == "-h" || os.Args[1] == "--help" || os.Args[1] == "help" {
		printHelp()
		os.Exit(0)
	}
	// Get home directory for "-s" option
	homeDir, _ = os.UserHomeDir()
	var timeIndex int = 1
	var silent bool = false
	if os.Args[1] == "-s" {
		silent = true
		timeIndex = 2
	}
	var numSecs int = decodeTime(os.Args[timeIndex])
	setTimer(numSecs, silent)
}
