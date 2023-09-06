package main

import (
	//"encoding/json"
	"fmt"
	//"io/ioutil"
	"os"
	//"sort"
	//"net/http"
	"golang.org/x/net/html"
	//"encoding/csv"
	"strings"
)

const FILE_PATH string = "/Programs/myRepos/goWeather/"
var homeDir string

func main() {
	homeDir, _ := os.UserHomeDir()
	dat, err := os.ReadFile(homeDir + FILE_PATH + "output.html")
	if err != nil {
		panic(err)
	}
	
	doc, err := html.Parse(strings.NewReader(string(dat)))
	if err != nil {
		panic(err)
	}
	//var test int = 0
	//inTable, inBody, inRow, inCell := false, false, false, false
	//var inTable bool = false
	var whichRow int = 0
	var daysParsed int = 0
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "table" {
			daysParsed++
			fmt.Println("HERE")
			fmt.Println(daysParsed)
			whichRow = 0
		}
		if n.Type == html.ElementNode && n.Data == "tr" {
			whichRow++
		}
		if n.Type == html.ElementNode && n.Data == "td" {
			if daysParsed > 7 {
				return
			}
			
			switch {
			case whichRow == 2:
				fmt.Println("Currently in: 2 (Weather Symbol)")
				fmt.Println(n.FirstChild.NextSibling.Attr[3].Val)
			case whichRow == 3:
				fmt.Println("Currently in: 3 (Chance of rain)")
				fmt.Printf("%+v\n", n)
			}
			
			/*
			if n.FirstChild.Data != "\n" { // Things which just work out of the box
				fmt.Println(n.FirstChild.Data)
				fmt.Printf("%+v\n", n.FirstChild)
				*/
			//if n.FirstChild.NextSibling.Attr[0].Val == "icon" { // Weather symbol
			//	fmt.Println(n.FirstChild.NextSibling.Attr[3].Val)
			//} //else if n.Attr[2].Val[0:6] == "precip" {
				//fmt.Printf("%+v\n", n)
			//x}
			/*
			} else if n.FirstChild.NextSibling.Attr[0].Val == "icon" { // Temperature
				fmt.Println(n.FirstChild.NextSibling.Attr[3].Val)
			} else {
				fmt.Printf("%+v\n", n.FirstChild.NextSibling)
			}
			*/
		}
		
	
	
	
		/*
		if n.Type == html.ElementNode && n.Data == "table" {
			fmt.Println(n.Data)
			if !inTable {
				inTable = true
			} else if inTable {
				os.Exit(0)
			}
		} else if inTable {
			fmt.Println(n.Data)
		}
		fmt.Println(n.Data)
		fmt.Println(n.Data)
		*/
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			f(c)
		}
	}
	f(doc)
}
