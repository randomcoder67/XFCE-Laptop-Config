package main

import (
	"golang.org/x/net/html"
	"strings"
	"encoding/json"
	"fmt"
	"net/http"
	"io/ioutil"
	"os"
	"bufio"
	"strconv"
	//"bytes"
	"os/exec"
)

// Function to get HTML from the internet
func getHTML(searchTerm []string) string {
	// Create search term by combining all arguments with "+" character
	var finalSearchTerm string = ""
	for _, word := range searchTerm {
		finalSearchTerm = finalSearchTerm + word + "+"
	}
	// Get search results (omit last character of finalSearchTerm as it will always be a trailing "+")
	resp, err := http.Get("https://www.youtube.com/results?search_query=" + finalSearchTerm[:len(finalSearchTerm)-1])
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	responseHTML, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}
	// Return the HTML
	return string(responseHTML)
}

// Function to extract JSON from HTML
func extractJSON(inputHTML string) map[string]interface{} {
	// Create string to hold extracted JSON
	var finalJSONString string = ""
	// Parse HTML
	doc, err := html.Parse(strings.NewReader(inputHTML))
	if err != nil {
		panic(err)
	}
	// Function to parse HTML and extract JSON
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Data == "script" {
			if len(n.Attr) > 1 {
				if n.Attr[1].Val == "https://www.youtube.com/s/desktop/dbf5c200/jsbin/desktop_polymer_enable_wil_icons.vflset/desktop_polymer_enable_wil_icons.js" {
					b := n
					// The required JSON is contained in script tag 7 after the matched one
					for i:=0; i<7; i++ {
						b = b.NextSibling
					}
					// Format the string properly, extracting only the JSON
					finalJSONString = strings.ReplaceAll(strings.ReplaceAll(b.FirstChild.Data, "var ytInitialData = ", ""), ";", "")
				}
			}
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			f(c)
		}
	}
	f(doc)
	// Unmarshal the JSON
	var finalJSON map[string]interface{}
	if err := json.Unmarshal([]byte(finalJSONString), &finalJSON); err != nil {
		panic(err)
	}
	// Return unmarshalled JSON
	return finalJSON
}

// Function to take the JSON, display the videos in a list, get user input and play selected video
func displayVideos(inputJSON map[string]interface{}) {
	// As the search results can vary in the types of content shown, a pre-made struct can't really be used, so have to manually go through the JSON
	// Get the actual videos section from JSON
	contents := inputJSON["contents"].(map[string]interface{})
	contents = contents["twoColumnSearchResultsRenderer"].(map[string]interface{})
	contents = contents["primaryContents"].(map[string]interface{})
	contents = contents["sectionListRenderer"].(map[string]interface{})
	contents = contents["contents"].([]interface{})[0].(map[string]interface{})
	contents = contents["itemSectionRenderer"].(map[string]interface{})
	listOfVideos := contents["contents"].([]interface{})
	
	// Create slice of slices to hold video data
	videoData := [][]string{}
	// Create index to display
	var index int = 1
	
	// Iterate through videos
	for _, data := range listOfVideos {
		// Iterate through keys
		for key, _ := range data.(map[string]interface{}) {
			// If key is "videoRenderer", then it is the right kindof video (i.e. actual search result, not "viewers also watched" or "latest from channel" etc
			if key == "videoRenderer" {
				// Get video ID, title, channel, publish time, length and views
				var videoID string = data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["videoId"].(string)
				var videoTitle string = data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["title"].(map[string]interface{})["runs"].([]interface{})[0].(map[string]interface{})["text"].(string)
				var videoChannel string = data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["longBylineText"].(map[string]interface{})["runs"].([]interface{})[0].(map[string]interface{})["text"].(string)
				
				// Sometimes videos don't have a published date, idk why, but this should handle that
				videoPublishedTimeMap, okay := data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["publishedTimeText"].(map[string]interface{})
				var videoPublishedTime string
				if !okay {
					videoPublishedTime = "No Publish Time"
				} else {
					videoPublishedTime = videoPublishedTimeMap["simpleText"].(string)
				}
				
				// Livestreams don't have a length, so have to check that the key exists
				videoLengthMap, okay := data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["lengthText"].(map[string]interface{})
				var videoLength string
				if !okay {
					videoLength = "Livestream"
				} else {
					videoLength = videoLengthMap["simpleText"].(string)
				}
				
				// Livestreams don't have views in the same format, and some have none at all
				var videoViews string
				// Check if the views part exists at all
				videoViewsMap, okay := data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["viewCountText"].(map[string]interface{})
				if !okay {
					videoViews = "no viewers"
				} else { // If it does, check if it's video format or livestream format
					videoViews, okay = videoViewsMap["simpleText"].(string)
					if !okay {
						videoViewsArray := data.(map[string]interface{})["videoRenderer"].(map[string]interface{})["viewCountText"].(map[string]interface{})["runs"].([]interface{})
						videoViews = videoViewsArray[0].(map[string]interface{})["text"].(string) + videoViewsArray[1].(map[string]interface{})["text"].(string)
					}
				}
				
				// Add video ID, title and channel to videoData, only data needed for mpv
				singleVideoData := []string{videoID, videoTitle, videoChannel}
				videoData = append(videoData, singleVideoData)
				// Print in format: "index: Title - Channel - Publish Time - Length - Views"
				fmt.Printf("%d: %s - %s - %s - %s - %s\n", index, videoTitle, videoChannel, videoPublishedTime, videoLength, videoViews)
				// Add one to index
				index++
			}
		}
	}
	
	// Get user input of video to watch
	fmt.Printf("Select Video to Watch (q to quit): ")
	in := bufio.NewReader(os.Stdin)
	videoSelection, _ := in.ReadString('\n')
	videoSelection = strings.ReplaceAll(videoSelection, "\n", "")
	
	// Exit if q or blank
	if videoSelection == "q" || videoSelection == "" {
		os.Exit(0)
	}
	
	// Convert to number
	videoSelectionNumber, err := strconv.Atoi(videoSelection)
	// Exit if couldn't convert to number, or if number out of range
	if err != nil || videoSelectionNumber >= index || videoSelectionNumber < 1 {
		os.Exit(0)
	}
	videoSelectionNumber--
	
	// Play video with mpv (ytdl-format=best used as the 720p YouTube video works the best with mpv)
	mpvVideoCommand := exec.Command("mpv", "--ytdl-format=best", "--title=" + videoData[videoSelectionNumber][1] + " - " + videoData[videoSelectionNumber][2], "https://www.youtube.com/watch?v=" + videoData[videoSelectionNumber][0])
	mpvVideoCommand.Start()
	
	/*
	// Outputing command debug info, leaving here in case something breaks in the future
	var outb, errb bytes.Buffer
	mpvVideoCommand.Stdout = &outb
	mpvVideoCommand.Stderr = &errb
	fmt.Println("https://www.youtube.com/watch?v=" + videoData[videoSelectionNumber][0])
	err = mpvVideoCommand.Start()
	mpvVideoCommand.Wait()
	fmt.Println("Err:", err)
	fmt.Println("stdout:", outb.String())
	fmt.Println("stderr:", errb.String())
	fmt.Println(mpvVideoCommand.String())
	*/
}
	
// Print help info
func printHelp() {
	fmt.Printf("Usage:\n  youtube -h/--help - Show Help\n  youtube search terms here - Search YouTube, spaces parsed as real spaces, quotes not needed\n")
}


func main() {
	// Check and parse arguments
	if len(os.Args) == 1 {
		fmt.Println("Error, no arguments or search term")
		printHelp()
		os.Exit(1)
	} else if len(os.Args) > 1 {
		if os.Args[1] == "-h" || os.Args[1] == "--help" {
			printHelp()
		} else {
			var pageHTML string = getHTML(os.Args[1:])
			var jsonData map[string]interface{} = extractJSON(pageHTML)
			displayVideos(jsonData)
		}
	}
}
