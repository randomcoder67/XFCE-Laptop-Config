#!/usr/bin/env python3

# Program to convert markdown file to groff ms macro file, and then compile to ps and convert to pdf

from markdown.extensions.tables import TableExtension
import markdown
import sys
from bs4 import BeautifulSoup
import subprocess
from os.path import expanduser

home = expanduser("~")

if not len(sys.argv) == 3:
	print("Error, incorrect number of arguments")
	exit()

fileToOpen = sys.argv[1]
fileToWrite = sys.argv[2]
fileNameToWrite = fileToWrite.partition(".")[0] # bugged, what if it's a path with .config/thing.a for example
tempFilePathMS = home + "/Programs/output/.temp/" + fileNameToWrite + ".ms"
tempFilePathPS = home + "/Programs/output/.temp/" + fileNameToWrite + ".ps"

f = open(fileToOpen, "r")
text = f.read()

toWrite = open(tempFilePathMS, "w")
toWrite.write(".nr HM 2c\n")

html = markdown.markdown(text, extensions=[TableExtension(use_align_attribute=True)])
#print(html)

#print(b)

soup = BeautifulSoup(html, "html.parser")


def paragraph(text):
	textA = text
	textA = textA.replace("<br/>", "\n.br")
	textA = textA.replace("<p>", "")
	textA = textA.replace("</p>", "")
	textA = textA.replace("<strong><em>", "\n.BI \"")
	textA = textA.replace("</em></strong>", "\"\c\n")
	textA = textA.replace("<strong>", "\n.B \"")
	textA = textA.replace("</strong>", "\"\c\n")
	textA = textA.replace("<em>", "\n.I \"")
	textA = textA.replace("</em>", "\"\c\n")
	toWrite.write(".PP\n" + textA + "\n")


def table(text):
	#print(text)
	table = text
	tableBody = table.find("tbody")
	rows = table.find_all("tr")
	alignmentLine = ""
	tableContents = ""
	inHeader = True
	inHeader2 = True
	for row in rows:
		if inHeader:
			cols = row.find_all("th")
		else:
			cols = row.find_all("td")
			inHeader = False
	currentItem = 1
	for item in cols:
		if "align" in item.attrs and inHeader2:
			alignmentLine = alignmentLine + item["align"] + " "
		elif inHeader2:
			alignmentLine = alignmentLine + "c" + " "
		tableContents = tableContents + item.contents[0]
		if currentItem == len(cols):
			tableContents = tableContents + "\n"
		else:
			tableContents = tableContents + ";"

		currentItem += 1
		inHeader2 = False
		alignmentLine = alignmentLine + "."
		alignmentLine = alignmentLine.replace("left", "l")
		alignmentLine = alignmentLine.replace("center", "c")
		alignmentLine = alignmentLine.replace("right", "r")
		tableString = ""
		tableString = tableString + ".TS" + "\n" + "tab(;) allbox;" + "\n" + alignmentLine + "\n"
		tableString = tableString + tableContents
	tableString = tableString + ".TE\n"
	toWrite.write(tableString)

def code(text):
	codeString = text[0]
	language = codeString.partition('\n')[0]
	codeString = codeString.replace(language + "\n", "")
	codeString = codeString.rstrip() # strip trailing newline
	tempPath = home + "/Programs/output/.temp/temp." + language # IMPROVE
	f = open(tempPath, "w")
	f.write(codeString)
	f.close()
	#result = subprocess.Popen(["highlight", "-O", "truecolor", fileName, "|", "groffhl"], stdout=subprocess.PIPE)
	ps = subprocess.run(["highlight", "-O", "truecolor", tempPath], check=True, capture_output=True) # get highlighted code
	processNames = subprocess.run(["groffhl"], input=ps.stdout, capture_output=True) # convert to groff format with groffhl
	codeFormatted = processNames.stdout.decode('utf-8').strip() # get result as string
	codeFormatted = codeFormatted.replace("]\n", "]\n.br\n") # add line breaks in the code part to make it format properly
	codeFormatted = ".CW\n" + codeFormatted
	# following code is to replace default highlight colours with my preffered colours
	codeFormatted = codeFormatted.replace("1.000000f", "0.169000f") # replace white with black
	codeFormatted = codeFormatted.replace("0.815686f 0.815686f 0.270588f", "0.000000f 0.000000f 1.000000f") # replace color of import
	codeFormatted = codeFormatted.replace("0.325490f 0.741176f 0.988235f", "0.000000f 0.502000f 0.000000f") # comments
	codeFormatted = codeFormatted.replace("0.058824f 0.576471f 0.058824f", "0.149000f 0.498000f 0.600000f") # name = value
	codeFormatted = codeFormatted.replace("0.411765f 0.780392f 0.537255f", "1.000000f 0.000000f 0.000000f") # null
	codeFormatted = codeFormatted.replace("0.901961f 0.298039f 0.901961f", "0.035000f 0.525000f 0.345000f") # numbers
	codeFormatted = codeFormatted.replace("0.776471f 0.254902f 0.776471f", "0.639000f 0.082000f 0.082000f") # string
	codeFormatted = codeFormatted.replace("0.972549f 0.819608f 0.819608f", "1.000000f 0.000000f 0.000000f") # newline
	toWrite.write(codeFormatted + "\n") # write to file

def header(text, size):
	headerText = text[0]
	toWrite.write(".ps +" + str(size * 5) + "\n")
	toWrite.write(".B\n")
	toWrite.write(headerText + "\n.br\n \n.ps\n")

def image(text):
	imgTag = text[0]
	altText = imgTag["alt"]
	fullPath = imgTag["src"]
	fullPath = fullPath.replace("~", home + "")
	fileName = fullPath.split('/')[-1]
	newFileName = fileName.partition('.')[0] + ".eps"
	outputPath = home + "/Programs/output/.images/" + newFileName
	subprocess.run(["convert", fullPath, outputPath])
	toWrite.write(".PSPIC -L " + outputPath + "\n")
	toWrite.write(".PP\n")
	toWrite.write(altText + "\n")


listA = soup.contents
for x in listA:
	if not x.name == None:
		if x.name == "h1":
			header(x.contents, 3)
		if x.name == "h2":
			header(x.contents, 2)
		if x.name == "h3":
			header(x.contents, 1)
		if x.name == "p":
			typeA = next(x.children)
		if typeA.name == "img":
			image(x.contents)
		elif typeA.name == "code":
			code(typeA.contents)
		else:
			paragraph(str(x))
		if x.name == "table":
			table(x)
#print("x: ")
#print(x)
#print("Content: ")
#print(x.contents)
#print("Children: ")
#for child in x.children:
# print(child)

#print(dir(x))
#for b in x.children:
# print(b)
#print(x.contents)
#for y in x:
# print(y)
#print("end")
#print("")
#print("")
#print("")


toWrite.close()


psFile = open(tempFilePathPS, "wb")
psBinaryProcess = subprocess.run(["groff", "-ms", "-tb", "-Tps", tempFilePathMS], check=True, capture_output=True) # get
psBinary = psBinaryProcess.stdout
psFile.write(psBinary)
psFile.close()

subprocess.run(["ps2pdf", tempFilePathPS, fileToWrite])
