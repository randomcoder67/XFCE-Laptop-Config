package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"math"
)

func parseInput(inputSize string, inputSpeed string) (float64, float64) {
	var sizeMultiplier int = 1000
	inputSize = strings.ToLower(inputSize)
	inputSpeed = strings.ToLower(inputSpeed)
	if strings.Contains(inputSize, "mb") {
		sizeMultiplier = 1
		inputSize = strings.ReplaceAll(inputSize, "mb", "")
	} else {
		inputSize = strings.ReplaceAll(inputSize, "gb", "")
	}
	
	var speedMultiplier int = 1
	if strings.Contains(inputSpeed, "gb/s") {
		speedMultiplier = 1000
		inputSpeed = strings.ReplaceAll(inputSpeed, "gb/s", "")
	} else {
		inputSpeed = strings.ReplaceAll(inputSpeed, "mb/s", "")
	}

	size, err := strconv.ParseFloat(inputSize, 64)
	if err != nil {
		panic(err)
	}
	speed, err := strconv.ParseFloat(inputSpeed, 64)
	if err != nil {
		panic(err)
	}
	
	return size*float64(sizeMultiplier), speed*float64(speedMultiplier)
}

func calculateTime(size float64, speed float64) string {
	var hours int = int((size/speed)/60/60)
	var minutes int = int(math.Round((size/speed)/60)) - hours*60
	return (fmt.Sprintf("This download will take %d hours %d minutes", hours, minutes))
}

func printHelp() {
	fmt.Printf("Usage: \n  downloadt 10gb[mb] 10mb/s[gb/s]\n")
}

func main() {
	if len(os.Args) == 3 {
		size, speed := parseInput(os.Args[1], os.Args[2])
		var answer string = calculateTime(size, speed)
		fmt.Println(answer)
	} else if len(os.Args) == 2 && (os.Args[1] == "-h" || os.Args[1] == "--help") {
		printHelp()
	} else {
		printHelp()
		os.Exit(1)
	}
}
