package main
import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
)

func main() {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		os.Exit(1)
	}
	
	files, err := ioutil.ReadDir(homeDir + "/Programs/output/log/")
	if err != nil {
		os.Exit(1)
	}
	var allSongs = make(map[string]int)
	
	for _, file := range files {
		//fmt.Println(file.Name())
		dat, err := os.ReadFile(homeDir + "/Programs/output/log/" + file.Name())
		if err != nil {
			os.Exit(1)
		}
		bytesFile := dat
		var curJSON map[string]interface{}
		if err := json.Unmarshal(bytesFile, &curJSON); err != nil {
			panic(err)
		}
		for _, v := range curJSON {
			curSong := (v.(map[string]interface{})["song"]).(string)
			//var curSong string = "N/A"
			if curSong != "N/A" {
				if allSongs[curSong] == 0 {
					allSongs[curSong] = 1
				} else {
					var tempNum int = allSongs[curSong] + 1
					allSongs[curSong] = tempNum
				}
			}
		}
	}
	//for x, y := range allSongs {
	//	fmt.Printf("%s: %d\n", x, y)
	//}
	
	keys := make([]string, 0, len(allSongs))
	
	for key := range allSongs {
		keys = append(keys, key)
		//fmt.Println(key)
	}
	//fmt.Printf("%T\n", keys)
	
	sort.SliceStable(keys, func(i, j int) bool{
		return allSongs[keys[i]] > allSongs[keys[j]]
	})
	
	for i := 0; i < len(keys); i++ {
		fmt.Printf("%d: %s (%d)\n", i+1, keys[i], allSongs[keys[i]])
	}
	
	//fmt.Println(keys)

	/*
	byt := []byte(`{ "03": { "stuff": "Went out on bike, to shops and back, not very fit", "trips": "home, out on bike", "video": "N/A", "song": "N/A", "learn": "nothing" } }`)
	var dat map[string]interface{}
	
	if err := json.Unmarshal(byt, &dat); err != nil {
		panic(err)
	}
	
	fmt.Println(dat)
	
	fmt.Println(dat["03"].["trips"])
	*/
	//fmt.Printf("%T\n", dat)
	//fmt.Printf("%T\n", dat["03"])
}
