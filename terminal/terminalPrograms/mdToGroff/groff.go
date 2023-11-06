package main

import (
	"fmt"
	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/ast"	
	"github.com/gomarkdown/markdown/parser"
	"os"
	"io"
	"strings"
	"regexp"
	"strconv"
	"os/exec"
)
/*
func modifyAst(doc ast.Node) ast.Node {
	ast.WalkFunc(doc, func(node ast.Node, entering bool) ast.WalkStatus {
		if quote, ok := node.(*ast.BlockQuote); ok && entering {
			//fmt.Printf("%T\n", quote.Children[0].AsContainer().Children[0])
			//fmt.Println(string(quote.Children[0].AsContainer().Children[0].AsLeaf().Literal))
			//var stringA string = ast.ToString(quote)
			//fmt.Println(stringA)
			//fmt.Println(quote.Children[0].Text)
			//fmt.Printf("here%s", quote)
			fmt.Println(quote)
		}
		return ast.GoToNext
	})
	return doc
}
*/

const tempMSFileName string = "/Programs/output/.temp/tempGoMS.ms"
const tempPSFileName string = "/Programs/output/.temp/tempGoPS.ps"

const IMAGE_PATH string = "/Programs/output/.temp/groffImages/"

var inBlockQuote bool = false
var tableAlignmentLengths []int
var currentTableLength int = 0
var pastTableLength int = 0
var inStrong bool = false
var orderedList bool = false
var atFirstListEntry bool = false
var inList bool = false
var inImage bool = false

var homeDir string

var imageLocs = []string{}
var imageDests = []string{}

func sliceContains(sliceA []string, stringA string) bool {
	for _, entry := range sliceA {
		if stringA == entry { return true }
	}
	return false
}

func renderList(w io.Writer, p *ast.List, entering bool) {
	if entering {
		inList = true
		atFirstListEntry = true
		if p.ListFlags == 17 {
			orderedList = true
			var startNumber string = strconv.Itoa(p.Start + 1) // Glitch here, not working
			//fmt.Println(startNumber)
			io.WriteString(w, ".nr step " + startNumber + " 1\n")
		} else {
			orderedList = false
		}
	} else {
		inList = false
	}
}

func renderListItem(w io.Writer, p *ast.ListItem, entering bool) {
	if entering {
		if orderedList {
			if atFirstListEntry {
				io.WriteString(w, ".IP \\n[step] 2\n")
			} else {
				io.WriteString(w, ".IP \\n+[step]\n")
			}
		} else {
			if atFirstListEntry {
				io.WriteString(w, ".IP \\[bu] 2\n")
			} else {
				io.WriteString(w, ".IP \\[bu]\n")
			}
		}
		atFirstListEntry = false
	} else {
		io.WriteString(w, "\n")
	}
}

func renderText(w io.Writer, p *ast.Text) {
	var textString string = string(p.Literal)
	if inStrong {
		io.WriteString(w, "\n.B \"" + textString + "\"\\c\n")
	} else if !inImage {
		io.WriteString(w, textString)
	}
}

func renderLineBreak(w io.Writer, p *ast.Hardbreak) {
	io.WriteString(w, "\n.br\n")
}

func renderItalic(w io.Writer, p *ast.Emph, entering bool) {
	if entering {
		if inStrong {
			inStrong = false
			io.WriteString(w, "\n.BI \"")
		} else {
			io.WriteString(w, "\n.I \"")
		}
	} else {
		io.WriteString(w, "\"\\c\n")
	}
}

func renderBold(w io.Writer, p *ast.Strong, entering bool) {
	if entering {
		inStrong = true
	} else {
		inStrong = false
	}
}

func renderMonospace(w io.Writer, p *ast.Code, entering bool) {
	var codeString string = string(p.AsLeaf().Literal)
	codeString = "\n.CW \"" + codeString + "\"\\c\n"
	io.WriteString(w, codeString)
}

func renderTable(w io.Writer, p *ast.Table, entering bool) {
	numTableString := strconv.Itoa(len(tableAlignmentLengths))
	if entering {
		io.WriteString(w, ".TS\ntab(;) allbox;\nALIGNMENT_TO_REPLACE" + numTableString + "\n")
	} else {
		tableAlignmentLengths = append(tableAlignmentLengths, pastTableLength)
		io.WriteString(w, ".TE\n")
	}
}

func renderTableRow(w io.Writer, p *ast.TableRow, entering bool) {
	if !entering {
		pastTableLength = currentTableLength
		currentTableLength = 0
		io.WriteString(w, "\n")
	}
}

func renderTableCell(w io.Writer, p *ast.TableCell, entering bool) {
	if !entering {
		currentTableLength++
		io.WriteString(w, ";")
	}
}

func renderHeading(w io.Writer, p *ast.Heading, entering bool) {
	if entering {
		var fontSize string = strconv.Itoa(18-(p.Level*5))
		io.WriteString(w, "\n.ps +" + fontSize + "\n.B\n")
	} else {
		io.WriteString(w, "\n.br\n.ps\n")
	}
}

func renderBlockQuote(w io.Writer, p *ast.BlockQuote, entering bool) {
	if entering {
		inBlockQuote = true
		io.WriteString(w, ".LP\n> ")
	} else {
		inBlockQuote = false
		io.WriteString(w, "\n")
	}
}

func renderParagraph(w io.Writer, p *ast.Paragraph, entering bool) {
	if !inBlockQuote && !inList {
		if entering {
			io.WriteString(w, ".LP\n")
		} else {
			io.WriteString(w, "\n")
		}
	}
}

func renderCodeBlock(w io.Writer, p *ast.CodeBlock) {
	var codeString string = string(p.AsLeaf().Literal)
	//var language string = string(p.Info)
	codeString = ".CW\n" + codeString
	var re = regexp.MustCompile(`\n([^\s])`)
	codeString = re.ReplaceAllString(codeString, "\n.br\n$1")
	io.WriteString(w, codeString)
}

func myRenderHook(w io.Writer, node ast.Node, entering bool) (ast.WalkStatus, bool) {
	//fmt.Printf("%T\n", node)
	if text, ok := node.(*ast.Text); ok{
		renderText(w, text)
		return ast.GoToNext, true
	}
	if lineBreak, ok := node.(*ast.Hardbreak); ok{
		renderLineBreak(w, lineBreak)
		return ast.GoToNext, true
	}
	if emph, ok := node.(*ast.Emph); ok{
		renderItalic(w, emph, entering)
		return ast.GoToNext, true
	}
	if strong, ok := node.(*ast.Strong); ok{
		renderBold(w, strong, entering)
		return ast.GoToNext, true
	}
	if monospace, ok := node.(*ast.Code); ok{
		renderMonospace(w, monospace, entering)
		return ast.GoToNext, true
	}
	if para, ok := node.(*ast.Paragraph); ok{
		renderParagraph(w, para, entering)
		return ast.GoToNext, true
	}
	if heading, ok := node.(*ast.Heading); ok{
		renderHeading(w, heading, entering)
		return ast.GoToNext, true
	}
	if quote, ok := node.(*ast.BlockQuote); ok{
		renderBlockQuote(w, quote, entering)
		return ast.GoToNext, true
	}
	if table, ok := node.(*ast.Table); ok{
		renderTable(w, table, entering)
		return ast.GoToNext, true
	}
	if tableRow, ok := node.(*ast.TableRow); ok{
		renderTableRow(w, tableRow, entering)
		return ast.GoToNext, true
	}
	if tableCell, ok := node.(*ast.TableCell); ok{
		renderTableCell(w, tableCell, entering)
		return ast.GoToNext, true
	}
	if _, ok := node.(*ast.TableHeader); ok{
		return ast.GoToNext, true
	}
	if _, ok := node.(*ast.TableBody); ok{
		return ast.GoToNext, true
	}
	if code, ok := node.(*ast.CodeBlock); ok{
		renderCodeBlock(w, code)
		return ast.GoToNext, true
	}
	if list, ok := node.(*ast.List); ok{
		renderList(w, list, entering)
		return ast.GoToNext, true
	}
	if listItem, ok := node.(*ast.ListItem); ok{
		renderListItem(w, listItem, entering)
		return ast.GoToNext, true
	}
	if image, ok := node.(*ast.Image); ok{
		if entering {
			inImage = true
			//fmt.Printf("IMAGE ALT TEXT: %s\n", image.Children[0].AsLeaf().Literal)
			//fmt.Printf("IMAGE PATH: %s\n", image.Destination)
			// Split image path to get only filename
			imagePathSplit := strings.Split(string(image.Destination), "/")
			// Create full final filename
			var startOfExtIndex int = strings.LastIndex(imagePathSplit[len(imagePathSplit)-1], ".")
			var finalPath string = homeDir + IMAGE_PATH + imagePathSplit[len(imagePathSplit)-1][:startOfExtIndex]
			// Add original path to imageLocs
			imageLocs = append(imageLocs, string(image.Destination))
			
			// Check if finalPath is already in imageDests, if it is, modify it until it's not
			for sliceContains(imageDests, finalPath) {
				finalPath = finalPath + "A"
			}
			// Once done, add to imageDests
			imageDests = append(imageDests, finalPath)
			
			// Write image (left align) and alt text to ms text
			io.WriteString(w, ".PDFPIC -L " + finalPath + ".pdf" + "\n.br\n" + string(image.Children[0].AsLeaf().Literal) + "\n")
		} else { inImage = false }
		return ast.GoToNext, true
	}
	return ast.GoToNext, false
}

func newGroffRenderer() *html.Renderer {
	opts := html.RendererOptions {
		Flags: html.CommonFlags,
		RenderNodeHook: myRenderHook,
	}
	return html.NewRenderer(opts)
}


func mdToHTML(md []byte) []byte {
	// create markdown parser with extensions
	extensions := parser.CommonExtensions | parser.AutoHeadingIDs | parser.NoEmptyLineBeforeBlock
	p := parser.NewWithExtensions(extensions)
	doc := p.Parse(md)
	// create HTML renderer with extensions
	renderer := newGroffRenderer()
	//fmt.Println(doc)
	return markdown.Render(doc, renderer)
}

func main() {
	homeDir, _ = os.UserHomeDir()
	// Get arguments 
	var inputFileName string
	var outputFileName string
	//var outputFileName string
	if len(os.Args) == 3 {
		inputFileName = os.Args[1]
		outputFileName = os.Args[2]
		//outputFileName = os.Args[2]
	} else { // Exit if wrong number 
		fmt.Println("Error, incorrect number of arguments")
		fmt.Println("Correct format: groffdoc inputFile.md outputFile.pdf")
		os.Exit(0)
	}
	
	// Open markdown input file 
	dat, err := os.ReadFile(inputFileName)
	if err != nil {
		os.Exit(1)
	}
	var markdown string = string(dat)
	
	md := []byte(markdown)

	// Get the .ms text
	html := mdToHTML(md)
	var htmlFinal string = string(html)
	
	// Replace the alignment temp strings with the proper alignment strings
	lenA := len(tableAlignmentLengths)
	for i:=0; i<lenA; i++ {
		var stringToReplace string = "ALIGNMENT_TO_REPLACE" + strconv.Itoa(lenA-1-i)
		var toReplaceWith string = ""
		for j:=0; j<tableAlignmentLengths[lenA-1-i]; j++ {
			toReplaceWith = toReplaceWith + "l "
		}
		toReplaceWith = toReplaceWith + "."
		toReplaceWith = strings.ReplaceAll(toReplaceWith, " .", ".")
		//fmt.Printf("%s, %s\n", stringToReplace, toReplaceWith)
		htmlFinal = strings.ReplaceAll(htmlFinal, stringToReplace, toReplaceWith)
	}
	
	//fmt.Println(imageLocs)
	//fmt.Println(imageDests)
	
	for i, originalPath := range imageLocs {
		cmd := exec.Command("convert", "-density", "200", "-units", "PixelsPerInch", originalPath, imageDests[i] + ".pdf")
		err = cmd.Start(); if err != nil {
			panic(err)
		}
		cmd.Wait()
	}
	
	// Get temp .ms file location and save .ms text to file
	//homeDir, _ := os.UserHomeDir()
	//msFileName := homeDir + tempMSFileName
	htmlFinal = ".nr HM 2c\n" + htmlFinal // Adding header to stop text from starting halfway down page 
	
	//fmt.Println(htmlFinal)
	
	// Setup and run command to convert to PS file with groff 
	cmd := exec.Command("groff", "-ms", "-tb" ,"-UT", "pdf")
	fmt.Println(htmlFinal)
	cmd.Stdin = strings.NewReader(htmlFinal)
	outfile, err := os.Create(outputFileName)
	if err != nil {
		panic(err)
	}
	defer outfile.Close()
	cmd.Stdout = outfile
	
	err = cmd.Start(); if err != nil {
		panic(err)
	}
	cmd.Wait()
	
}
