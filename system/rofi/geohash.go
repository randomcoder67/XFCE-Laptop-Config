package main

import (
	"fmt"
	"os"
	"strconv"
)

const BASE_32 string = "0123456789bcdefghjkmnpqrstuvwxyz"

func main() {
	if len(os.Args) < 3 {
		panic("Error, not enough arguments")
	}
	
	var lat string = os.Args[1]
	var lon string = os.Args[2]
	var precision string = "12"
	if len(os.Args) == 4 {
		precision = os.Args[3]
	}
	
	fmt.Println(encode(lat, lon, precision))
}

func getFloat64(input string) float64 {
	res, err := strconv.ParseFloat(input, 64)
	if err != nil {
		panic(err)
	}
	return res
}

func getInt(input string) int {
	res, err := strconv.Atoi(input)
	if err != nil {
		panic(err)
	}
	return res
}

func encode(latInput, lonInput, precisionInput string) string {
	var lat float64 = getFloat64(latInput)
	var lon float64 = getFloat64(lonInput)
	var precision int = getInt(precisionInput)
	
	var n, s int = 0, 0
	var o bool = true
	var r, c, d, l float64 = -90, 90, -180, 180
	var encodedString string = ""
	
	for len(encodedString) < precision {
		if o {
			var e2 float64 = (d + l) / 2
			if lon >= e2 {
				n = 2 * n + 1
				d = e2
			} else {
				n = n * 2
				l = e2
			}
		} else {
			var t2 float64 = (r + c) / 2
			if lat >= t2 {
				n = 2 * n + 1
				r = t2
			} else {
				n = n * 2
				c = t2
			}
		}
		o = !o
		s++
		if s == 5 {
			encodedString = encodedString + string(BASE_32[n])
			s = 0
			n = 0
		}
	}
	
	return encodedString
}
