package main

import (
	"os"
	"io"
	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/ast"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/parser"
	"fmt"
)

// Function to render links, renders normally except changes .md extension to .html extension
func renderLink(w io.Writer, p *ast.Link, entering bool) {
	// Format: <a href="https://www.nasa.gov/multimedia/imagegallery/iotd.html" target="_blank">NASA Image of the Day</a>
	if entering {
		var link string = string(p.Destination)
		if link[len(link)-3:] == ".md" {
			link = link[:len(link)-3] + ".html"
		}
		io.WriteString(w, "<a href=\"" + link + "\" target=\"_blank\">")
	} else {
		io.WriteString(w, "</a>")
	}
}

func myRenderHook(w io.Writer, node ast.Node, entering bool) (ast.WalkStatus, bool) {
	if text, ok := node.(*ast.Link); ok{
		renderLink(w, text, entering)
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

func renderFolder(dirName string) {
	fmt.Println("Not yet implemented")
}

func printHelp() {
	fmt.Printf("Usage:\n  render input.md [output.html] (defaults to input with .html extension)\n  render -f inputDir/ outputDir/\n")
}

func main() {
	if len(os.Args) == 4 {
		if os.Args[1] == "-f" {
			renderFolder(os.Args[2])
		} else {
			fmt.Println("Error, incorrectly formatted arguments")
			printHelp()
			os.Exit(1)
		}
	} else if len(os.Args) == 3 || len(os.Args) == 2 {
		mds, _ := os.ReadFile(os.Args[1])
		md := []byte(mds)
		html := mdToHTML(md)
		
		var outputFileName string
		if len(os.Args) == 3 { // If output filename is given, assign it to outputFileName
			outputFileName = os.Args[2]
		} else { // Otherwise change extension of input file from ".md" to ".html" and assign to outputFileName
			outputFileName = os.Args[1][:len(os.Args[1])-3] + ".html"
		}
		err := os.WriteFile(outputFileName, html, 0666)
		if err != nil {
			panic(err)
		}
	} else {
		fmt.Println("Error, incorrectly formatted arguments")
		printHelp()
		os.Exit(1)
	}
}
