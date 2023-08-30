package main

import (
	"github.com/pwiecz/go-fltk"
	"fmt"
	"github.com/gomarkdown/markdown"
	"github.com/gomarkdown/markdown/html"
	"github.com/gomarkdown/markdown/ast"	
	"github.com/gomarkdown/markdown/parser"
	"io"
	"os"
	"strings"
	"image"
	_ "image/png"
	"bytes"
)


const WIDTH = 1500
const HEIGHT = 1000
const FONT_SIZE = 20
const VISIBLE_LINES = 35

const BACKGROUND_COLOUR = 0x2B2B2B00
const FOREGROUND_COLOUR = 0xF9F7F300
const LIGHT_GRAY = 0xeeeeee00
const BLUE = 0x42A5F500
const SEL_BLUE = 0x2196F300

var homeDir string
const README_FILE_LOCTATION = "/Programs/configure/README.md"

var inStrong bool = false
var inItalic bool = false
var inHeading bool = false

var textSlice = []string{""}
var stextSlice = []string{""}
var currentIndex int = 0
var currentPage int = 1

func checkIfAtEnd(padding int) {
	var currentEffectivePos int = strings.Count(textSlice[currentIndex], "\n") + padding
	if currentEffectivePos > 34 {
		currentIndex++
		textSlice = append(textSlice, "")
		stextSlice = append(stextSlice, "")
	}
}

func renderText(w io.Writer, p *ast.Text) {
	checkIfAtEnd(0)
	var textString string = string(p.Literal)
	textSlice[currentIndex] = textSlice[currentIndex] + textString
	if inStrong {
		stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("B", len(textString))
	} else if inItalic {
		stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("C", len(textString))
	} else if inHeading {
		stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("F", len(textString))
	} else {
		stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("A", len(textString))
	}
}

func renderLineBreak(w io.Writer, p *ast.Hardbreak) {
	checkIfAtEnd(0)
	textSlice[currentIndex] = textSlice[currentIndex] + "\n"
	stextSlice[currentIndex] = stextSlice[currentIndex] + "A"
}

func renderItalic(w io.Writer, p *ast.Emph, entering bool) {
	if entering {
		inItalic = true
	} else {
		inItalic = false
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
	textSlice[currentIndex] = textSlice[currentIndex] + codeString
	stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("D", len(codeString))
}

func renderHeading(w io.Writer, p *ast.Heading, entering bool) {
	checkIfAtEnd(2*(6-p.Level))
	if entering {
		// Don't add a newline before the heading if at start of column
		var maybeNewLine string = ""
		var addExtraA int = 0
		if textSlice[currentIndex] != "" {
			maybeNewLine = "\n"
			addExtraA = 1
		}
		textSlice[currentIndex] = textSlice[currentIndex] + maybeNewLine + strings.Repeat("#", p.Level) + "  "
		stextSlice[currentIndex] = stextSlice[currentIndex] + strings.Repeat("A", p.Level+2+addExtraA)
		inHeading = true
	} else {
		textSlice[currentIndex] = textSlice[currentIndex] + "\n"
		stextSlice[currentIndex] = stextSlice[currentIndex] + "A"
		inHeading = false
	}
}

func renderParagraph(w io.Writer, p *ast.Paragraph, entering bool) {
	checkIfAtEnd(0)
	textSlice[currentIndex] = textSlice[currentIndex] + "\n"
	stextSlice[currentIndex] = stextSlice[currentIndex] + "A"
}

func myRenderHook(w io.Writer, node ast.Node, entering bool) (ast.WalkStatus, bool) {
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
	return ast.GoToNext, false
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

func newGroffRenderer() *html.Renderer {
	opts := html.RendererOptions {
		Flags: html.CommonFlags,
		RenderNodeHook: myRenderHook,
	}
	return html.NewRenderer(opts)
}

func main() {
	// Get home directory
	homeDir, _ = os.UserHomeDir()
	// Open and read README.md file
	dat, err := os.ReadFile(homeDir + README_FILE_LOCTATION)
	if err != nil {
		os.Exit(1)
	}
	var markdown string = string(dat)
	md := []byte(markdown)
	
	// Pass the file contents to the formatting functions
	mdToHTML(md)
	
	/*
	// Remove any newlines at the start of a column
	for i:=0; i<currentIndex; i++ {
		var numNewLines int = 0
		for true {
			if string(textSlice[i][numNewLines]) != "\n" {
				break
			}
			numNewLines++
		}
		textSlice[i] = textSlice[i][numNewLines:]
		stextSlice[i] = stextSlice[i][numNewLines:]
	}
	*/
	
	// Setup fonts
	fltk.SetFont(10, "Roboto Regular")
	fltk.SetFont(11, "Roboto Regular Bold")
	fltk.SetFont(12, "Roboto Regular Italic")
	fltk.SetFont(13, "Roboto Mono")
	fltk.SetFont(14, "Roboto Mono Bold")
	fltk.SetFont(15, "Roboto Mono Italic")
	
	// Setup styles
	entries := []fltk.StyleTableEntry {
		fltk.StyleTableEntry{ // A = Normal Text 
			FOREGROUND_COLOUR,
			10,
			FONT_SIZE,
		},
		fltk.StyleTableEntry{ // B = Bold Text
			FOREGROUND_COLOUR,
			11,
			FONT_SIZE,
		},
		fltk.StyleTableEntry{ // C = Italic Text
			FOREGROUND_COLOUR,
			12,
			FONT_SIZE,
		},
		fltk.StyleTableEntry{ // D = Monospace Text 
			FOREGROUND_COLOUR,
			13,
			FONT_SIZE,
		},
		fltk.StyleTableEntry{ // E = Monospace Bold Text
			FOREGROUND_COLOUR,
			14,
			FONT_SIZE,
		},
		fltk.StyleTableEntry{ // F = Monospace Italic Text
			FOREGROUND_COLOUR,
			15,
			FONT_SIZE,
		},
	}
	
	// Create stuff 
	window := fltk.NewWindow(1800, 950)
	textDisplay1 := fltk.NewTextDisplay(0, 0, 600, 1000)
	textDisplay2 := fltk.NewTextDisplay(600, 0, 600, 1000)
	textDisplay3 := fltk.NewTextDisplay(1200, 0, 600, 1000)
	buf1 := fltk.NewTextBuffer()
	sbuf1 := fltk.NewTextBuffer()
	buf2 := fltk.NewTextBuffer()
	sbuf2 := fltk.NewTextBuffer()
	buf3 := fltk.NewTextBuffer()
	sbuf3 := fltk.NewTextBuffer()
	
	buf1.SetText(textSlice[0])
	sbuf1.SetText(stextSlice[0])
	textDisplay1.SetHighlightData(sbuf1, entries)
	textDisplay1.SetBuffer(buf1)
	textDisplay1.SetBox(0)
	textDisplay1.SetColor(BACKGROUND_COLOUR)
	textDisplay1.SetWrapMode(1, 500)
	textDisplay1.SetTextSize(20)
	
	buf2.SetText(textSlice[1])
	sbuf2.SetText(stextSlice[1])
	textDisplay2.SetHighlightData(sbuf2, entries)
	textDisplay2.SetBuffer(buf2)
	textDisplay2.SetBox(0)
	textDisplay2.SetColor(BACKGROUND_COLOUR)
	textDisplay2.SetWrapMode(1, 500)
	
	buf3.SetText(textSlice[2])
	sbuf3.SetText(stextSlice[2])
	textDisplay3.SetHighlightData(sbuf3, entries)
	textDisplay3.SetBuffer(buf3)
	textDisplay3.SetBox(0)
	textDisplay3.SetColor(BACKGROUND_COLOUR)
	textDisplay3.SetWrapMode(1, 500)
	
	// Icon stuff
	dat16Icon, _ := os.ReadFile("images/16x16.png")
	dat32Icon, _ := os.ReadFile("images/32x32.png")
	dat48Icon, _ := os.ReadFile("images/48x48.png")
	dat64Icon, _ := os.ReadFile("images/64x64.png")
	dat128Icon, _ := os.ReadFile("images/128x128.png")
	decoded16Icon, _, err := image.Decode(bytes.NewReader(dat16Icon))
	decoded32Icon, _, err := image.Decode(bytes.NewReader(dat32Icon))
	decoded48Icon, _, err := image.Decode(bytes.NewReader(dat48Icon))
	decoded64Icon, _, err := image.Decode(bytes.NewReader(dat64Icon))
	decoded128Icon, _, err := image.Decode(bytes.NewReader(dat128Icon))
	rgb16Icon, _ := fltk.NewRgbImageFromImage(decoded16Icon)
	rgb32Icon, _ := fltk.NewRgbImageFromImage(decoded32Icon)
	rgb48Icon, _ := fltk.NewRgbImageFromImage(decoded48Icon)
	rgb64Icon, _ := fltk.NewRgbImageFromImage(decoded64Icon)
	rgb128Icon, _ := fltk.NewRgbImageFromImage(decoded128Icon)
	window.SetIcons([]*fltk.RgbImage{rgb16Icon, rgb32Icon, rgb48Icon, rgb64Icon, rgb128Icon})
	
	// Keys 
	window.SetEventHandler(func(event fltk.Event) bool {
		switch fltk.EventType() {
		case fltk.KEY:
			switch fltk.EventKey() {
				case fltk.ESCAPE:
					window.Destroy()
					return true
				case 'q', 'Q':
					window.Destroy()
					return true
				case 'd':
					if currentPage < 3 {
						currentPage++
						buf1.SetText(textSlice[currentPage*3-3])
						sbuf1.SetText(stextSlice[currentPage*3-3])
						buf2.SetText(textSlice[currentPage*3-2])
						sbuf2.SetText(stextSlice[currentPage*3-2])
						buf3.SetText(textSlice[currentPage*3-1])
						sbuf3.SetText(stextSlice[currentPage*3-1])
					}
					return true
				case 'a':
					if currentPage > 1 {
						currentPage--
						buf1.SetText(textSlice[currentPage*3-3])
						sbuf1.SetText(stextSlice[currentPage*3-3])
						buf2.SetText(textSlice[currentPage*3-2])
						sbuf2.SetText(stextSlice[currentPage*3-2])
						buf3.SetText(textSlice[currentPage*3-1])
						sbuf3.SetText(stextSlice[currentPage*3-1])
					}
					return true
				}
		case fltk.CLOSE:
			window.Destroy()
		}
		return false
	})
	
	window.End()
	window.Show()

	fltk.Run()
	
	fmt.Println(len(textSlice))
	fmt.Println("Done")
}
