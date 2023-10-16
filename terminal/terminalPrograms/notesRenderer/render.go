package main

import (
	"os"
	"io"
	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/ast"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
	"fmt"
	"io/ioutil"
	"strings"
	"strconv"
)

const CSS_FILE_LOCATION = "/Programs/terminal/terminalPrograms/notesRenderer/style.css"
var headings = []string{}
var inHeading bool = false

// Check if a given path points to a file, a directory, or nothing
func isFileOrDir(filename string) int { // 0 = file, 1 = directory, 2 = nothing
	fileInfo, err := os.Stat(filename)
	if err != nil {
		return 2
	} else if fileInfo.IsDir() {
		return 1
	}
	return 0
}

// Function to render links, renders normally except changes .md extension to .html extension
func renderLink(w io.Writer, p *ast.Link, entering bool) {
	// Format: <a href="https://www.nasa.gov/multimedia/imagegallery/iotd.html" target="_blank">NASA Image of the Day</a>
	if entering {
		var link string = string(p.Destination)
		if len(link) > 0 && link[len(link)-3:] == ".md" {
			link = link[:len(link)-3] + ".html"
		}
		io.WriteString(w, "<a href=\"" + link + "\" target=\"_self\">")
	} else {
		io.WriteString(w, "</a>")
	}
}

func renderHeading(w io.Writer, p *ast.Heading, entering bool) {
	level := strconv.Itoa(p.Level)
	if entering {
		io.WriteString(w, "<h" + level + " id=" + p.HeadingID + ">")
		inHeading = true
	} else {
		io.WriteString(w, "</h" + level + ">")
		inHeading = false
	}
}

func renderText(w io.Writer, p *ast.Text) {
	var textString string = string(p.Literal)
	io.WriteString(w, textString)
	if inHeading {
		headings = append(headings, textString)
	}
}

func myRenderHook(w io.Writer, node ast.Node, entering bool) (ast.WalkStatus, bool) {
	if text, ok := node.(*ast.Link); ok{
		renderLink(w, text, entering)
		return ast.GoToNext, true
	}
	if heading, ok := node.(*ast.Heading); ok{
		renderHeading(w, heading, entering)
		return ast.GoToNext, true
	}
	if text, ok := node.(*ast.Text); ok{
		renderText(w, text)
		return ast.GoToNext, true
	}
	return ast.GoToNext, false
}

func mdToHTML(md []byte) []byte {
	// create markdown parser with extensions
	extensions := parser.CommonExtensions | parser.AutoHeadingIDs | parser.NoEmptyLineBeforeBlock
	p := parser.NewWithExtensions(extensions)
	doc := p.Parse(md)

	// create HTML renderer with extensions
	//htmlFlags := html.CommonFlags | html.HrefTargetBlank
	opts := html.RendererOptions {
		Flags: html.CommonFlags | html.HrefTargetBlank,
		RenderNodeHook: myRenderHook,
	}
	renderer := html.NewRenderer(opts)

	return markdown.Render(doc, renderer)
}

func renderFolder(dirName string, outputDir string) {
	// Check dirName is a directory
	if isFileOrDir(dirName) != 1 {
		fmt.Println("Error, not a directory")
		os.Exit(1)
	}
	
	// Check outputDir has a slash
	if outputDir[len(outputDir)-1] != '/' {
		outputDir = outputDir + "/"
	}
	// Make the "new root" directory
	if isFileOrDir(outputDir) != 1 {
		os.Mkdir(outputDir, os.ModePerm)
	}
	// Copy style.css there
	homeDir, _ := os.UserHomeDir()
	source, err := os.Open(homeDir + CSS_FILE_LOCATION)
	if err != nil {
		panic(err)
	}
	// Open destination
	destination, err := os.Create(outputDir + "style.css")
	if err != nil {
		panic(err)
	}
	// Copy source to destination
	_, err = io.Copy(destination, source)
	if err != nil {
		panic(err)
	}
	
	// Recursive function to go through given folder and subfolders
	var listInDir func (string, int)
	listInDir = func(dirNameCur string, level int) {
		fmt.Println(level)
		files, err := ioutil.ReadDir(dirNameCur)
		if err != nil {
			panic(err)
		}
		for _, file := range files {
			if file.IsDir() { // If file is a directory, make it in new location and go a level deeper
				if isFileOrDir(strings.ReplaceAll(outputDir + dirNameCur + "/" + file.Name(), dirName, "")) != 1 {
					err := os.Mkdir(strings.ReplaceAll(outputDir + dirNameCur + "/" + file.Name(), dirName, ""), os.ModePerm)
					if err != nil {
						panic(err)
					}
				}
				listInDir(dirNameCur + "/" + file.Name(), level+1)
			} else { // If file is a file, add it to allFiles
				// Get new file name
				var newFileName string = strings.ReplaceAll(outputDir + dirNameCur + "/" + file.Name(), dirName, "")
				// If file is a markdown file
				if newFileName[len(newFileName)-3:] == ".md" {
					// Change extension to html
					newFileName = newFileName[:len(newFileName)-3] + ".html"
					//fmt.Println(dirNameCur + "/" + file.Name(), newFileName)
					// Render file
					renderFile(dirNameCur + "/" + file.Name(), newFileName, level)
				} else { // If file is not a markdown file, just copy
					// Open source
					source, err := os.Open(dirNameCur + "/" + file.Name())
					if err != nil {
						panic(err)
					}
					// Open destination
					destination, err := os.Create(newFileName)
					if err != nil {
						panic(err)
					}
					// Copy source to destination
					_, err = io.Copy(destination, source)
					if err != nil {
						panic(err)
					}
				}
			}
		}
	}
	listInDir(dirName[:len(dirName)-1], 0)
}

func renderFile(inputFile string, outputFile string, level int) {
	// Open file
	mds, _ := os.ReadFile(inputFile)
	// Convert markdown to html
	md := []byte(mds)
	html := mdToHTML(md)
	
	// Write html to file
	var cssInclude string = "<link rel=\"stylesheet\" type=\"text/css\" href=\"" + strings.Repeat("../", level) + "style.css\"/>"
	err := os.WriteFile(outputFile, []byte(cssInclude + string(html)), 0666)
	if err != nil {
		panic(err)
	}
}

func printHelp() {
	fmt.Printf("Usage:\n  render input.md [output.html] (defaults to input with .html extension)\n  render -f inputDir/ outputDir/\n")
}

func main() {
	if len(os.Args) == 4 {
		if os.Args[1] == "-f" {
			renderFolder(os.Args[2], os.Args[3])
		} else {
			fmt.Println("Error, incorrectly formatted arguments")
			printHelp()
			os.Exit(1)
		}
	} else if len(os.Args) == 3 || len(os.Args) == 2 {
		var outputFileName string
		if len(os.Args) == 3 { // If output filename is given, assign it to outputFileName
			outputFileName = os.Args[2]
		} else { // Otherwise change extension of input file from ".md" to ".html" and assign to outputFileName
			outputFileName = os.Args[1][:len(os.Args[1])-3] + ".html"
		}
		renderFile(os.Args[1], outputFileName, 0)
	} else {
		fmt.Println("Error, incorrectly formatted arguments")
		printHelp()
		os.Exit(1)
	}
	fmt.Println(headings)
}
