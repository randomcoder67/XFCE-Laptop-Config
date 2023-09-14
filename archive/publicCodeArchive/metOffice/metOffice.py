#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import pandas as pd
from metOfficeDict import weatherSymbols, windDirection, rowLabels, weatherColors
import curses
from curses import wrapper
import os
import signal
import sys

# Ctrl + C to quit working properly 
def signal_handler(sig, frame):
	print('q')
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

# Display avalible locations and allow user to pick (unless there is only one)
fileLocation = os.path.realpath(__file__) # Get location of this file 
locationsFileName = fileLocation.rpartition("/")[0] + "/locations.csv"

# Open file and read all entries, if only 1, use automatically, else allow use to pick
f = open(locationsFileName, "r")
lines = f.readlines()
location = ""
if len(lines) == 1:
	location = lines[0].split("|")[1]
else:
	for i, x in enumerate(lines):
		print(str(i+1) + ": " + x.split("|")[0])
	selectedLocation = input("Which location? ")
	if selectedLocation == "q" or selectedLocation == "exit":
		exit()
	if int(selectedLocation) > (i+1):
		exit()
	location = lines[int(selectedLocation)-1].split("|")[1]

location = location.rstrip()

# Get webpage 
r = requests.get('https://www.metoffice.gov.uk/weather/forecast/' + location)
soup = BeautifulSoup(r.text, 'html.parser')

# Get days (to print which day it is at the top of the page)
days = soup.find_all("span", {"class": "timeline-date"})
dateStrings = []
for day in days:
	dateStrings.append(day.parent.text)

# Replace images with alt text for images 
things = soup.find_all('img')
for x in things:
	#print(x["alt"])
	newpara = "<td>" + x["alt"] + "</td>"
	x.replaceWith(x["alt"])

# Collect all days into a list of lists
allDays = []
tables = soup.find_all("table")

for i, table in enumerate(tables):
	if i == 7: # If i is 7, at end of days 
		break
	
	day = [] # Make array for current day
	table_head = table.find("thead") # Parse table 
	rows = table_head.find_all("tr")
	
	for index, row in enumerate(rows):
		cols = row.find_all("th")
		cols = [ele.text.strip() for ele in cols]
		day.append([ele for ele in cols if ele])
	day[0].pop(0) # First timestamp is duplicated, drop it
	
	table_body = table.find("tbody")
	rows = table_body.find_all("tr")

	for index, row in enumerate(rows):
		cols = row.find_all("td")
		cols = [ele.text.strip() for ele in cols]
		day.append([ele for ele in cols if ele])
		if index == 5:
			day.append([ele for ele in cols if ele])
	
	# Correctly format wind stuff 
	for index, condition in enumerate(day[5]):
		day[5][index] = windDirection[condition.split("\n")[0]]
		day[6][index] = condition.split('\n\n')[1] + " mph"
	
	for index, condition in enumerate(day[7]):
		day[7][index] = condition + " mph"
	allDays.append(day)

# Main function for curses
def main(cursesScreen):
	legend = False
	currentDay = 0
	counter = 1
	currentPosition = 9
	while True:
		if legend:
			cursesScreen.clear()
			index = 2
			for item, symbol in weatherSymbols.items():
				index += 1
				if item in weatherColors["colorYellow"]:
					condColor = YELLOW
				elif item in weatherColors["colorWhite"]:
					condColor = WHITE
				elif item in weatherColors["colorMagenta"]:
					condColor = MAGENTA
				elif item in weatherColors["colorRed"]:
					condColor = RED
				elif item in weatherColors["colorGreen"]:
					condColor = GREEN
				elif item in weatherColors["colorBlue"]:
					condColor = BLUE
				elif item in weatherColors["colorCyan"]:
					condColor = CYAN
				elif item in weatherColors["colorBlue"]:
					condColor = BLUE
				if index < 18:
					cursesScreen.addstr(index, 1, symbol + "  ", condColor)
					cursesScreen.addstr(item)
				else:
					cursesScreen.addstr(index-15, 40, symbol + ": ", condColor)
					cursesScreen.addstr(item)
			cursesScreen.addstr(1, 1, "Legend:", YELLOW)
		else:
			cursesScreen.clear()
			curses.curs_set(0)
			#curses.start_color()
			
			# Define colours 
			curses.init_pair(1, curses.COLOR_RED, curses.COLOR_BLACK)
			curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)
			curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)
			curses.init_pair(4, curses.COLOR_BLUE, curses.COLOR_BLACK)
			curses.init_pair(5, curses.COLOR_MAGENTA, curses.COLOR_BLACK)
			curses.init_pair(6, curses.COLOR_CYAN, curses.COLOR_BLACK)
			curses.init_pair(7, curses.COLOR_WHITE, curses.COLOR_BLACK)
			#curses.init_color(17,353,392,494)
			#curses.init_pair(8, 17, curses.COLOR_BLACK)
			RED = curses.color_pair(1)
			GREEN = curses.color_pair(2)
			YELLOW = curses.color_pair(3)
			BLUE = curses.color_pair(4)
			MAGENTA = curses.color_pair(5)
			CYAN = curses.color_pair(6)
			WHITE = curses.color_pair(7)
			#DARK_BLUE = curses.color_pair(8)
			
			# Add current day to top of screen
			cursesScreen.addstr(0, 1, dateStrings[currentDay] + ":\t ", MAGENTA)
			
			lengthA = len(allDays[currentDay][0])
			
			if currentPosition > lengthA:
				rangeA = 9-(currentPosition-lengthA)
			else:
				rangeA = 9
			
			for row, text in enumerate(rowLabels):
				cursesScreen.addstr(row*2+2, 1, text + ":\t ", YELLOW)
			
			index = 1
			# Time
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][0][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, CYAN)
			index += 1
			
			# Condition
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][1][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break 
				if item in weatherColors["colorYellow"]:
					condColor = YELLOW
				elif item in weatherColors["colorWhite"]:
					condColor = WHITE
				elif item in weatherColors["colorMagenta"]:
					condColor = MAGENTA
				elif item in weatherColors["colorRed"]:
					condColor = RED
				elif item in weatherColors["colorGreen"]:
					condColor = GREEN
				elif item in weatherColors["colorBlue"]:
					condColor = BLUE
				elif item in weatherColors["colorCyan"]:
					condColor = CYAN
				elif item in weatherColors["colorBlue"]:
					condColor = BLUE
				cursesScreen.addstr(index*2, 30+itemIndex*8, weatherSymbols[item], condColor)
			index += 1
			
			# Precipitaton 
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][2][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				value = int(item.replace("%", "").replace("<", "").replace("≥", ""))
				if value < 15:
					precColor = CYAN
				elif value < 30:
					precColor = GREEN
				elif value < 65:
					precColor = YELLOW
				else:
					precColor = RED
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, precColor)
			index += 1
			
			# Temperature and Feels like temperature
			for iA in [3,4]:
				for itemIndex in range(0, rangeA):
					item = allDays[currentDay][iA][itemIndex-9+currentPosition]
					if itemIndex == currentPosition:
						break
					value = int(item.replace("°", ""))
					if value < 4:
						tempColor = BLUE
					elif value < 14:
						tempColor = MAGENTA
					elif value < 18:
						tempColor = CYAN
					elif value < 23:
						tempColor = YELLOW
					else:
						tempColor = RED
					cursesScreen.addstr(index*2, 30+itemIndex*8, item, tempColor) 
					
				index += 1
			
			# Wind Direction and speed 
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][5][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break 
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, WHITE)
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][6][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				value = int(item.replace(" mph", ""))
				if value < 4:
					windColor = WHITE
				elif value < 10:
					windColor = CYAN
				elif value < 18:
					windColor = GREEN
				elif value < 25:
					windColor = YELLOW
				else:
					windColor = RED
				cursesScreen.addstr(index*2+1, 30+itemIndex*8, item, windColor)
			index += 1
			
			# Wind gust 
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][7][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				value = int(item.replace(" mph", ""))
				if value < 4:
					windColor = WHITE
				elif value < 12:
					windColor = CYAN
				elif value < 24:
					windColor = GREEN
				elif value < 30:
					windColor = YELLOW
				else:
					windColor = RED
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, windColor)
			index += 1
			
			# Visibility
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][8][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				if item == "UN":
					visColor = WHITE
				elif item == "VP":
					visColor = RED
				elif item == "P":
					visColor = YELLOW
				elif item == "M":
					visColor = YELLOW
				elif item == "G":
					visColor = GREEN
				elif item == "VG":
					visColor = CYAN
				elif item == "E":
					visColor = CYAN
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, visColor)
			index += 1
			
			# Humidity
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][9][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, BLUE)
			index += 1
			
			# UV
			for itemIndex in range(0, rangeA):
				item = allDays[currentDay][10][itemIndex-9+currentPosition]
				if itemIndex == currentPosition:
					break
				if item == "-":
					uvColor = WHITE
				elif item in ["1","2"]:
					uvColor = GREEN
				elif item in ["3","4","5"]:
					uvColor = YELLOW
				elif item in ["6","7"]:
					uvColor = RED
				elif item in ["8","9","10"]:
					uvColor = RED
				elif item == "11":
					uvColor = MAGENTA
				cursesScreen.addstr(index*2, 30+itemIndex*8, item, uvColor)
			index += 1
		
		ch = cursesScreen.getch()
		
		if ch == ord("q"): # Quit program
			break
		elif ch == curses.KEY_RIGHT: # Go to next day (if possible)
			if not currentDay == 6:
				currentDay += 1
				currentPosition = 9	
		elif ch == curses.KEY_LEFT: # Go to previous day (if possible)
			if not currentDay == 0:
				currentDay -= 1
				currentPosition = 9
		elif ch == curses.KEY_UP: # Go back in day (if possible)
			if not currentPosition == 9:
				currentPosition -= 9
		elif ch == curses.KEY_DOWN: # Go forward in day (if possible)
			if currentPosition < lengthA:
				currentPosition += 9
		elif ch == ord("l"): # Display legend 
			if legend:
				legend = False
			else:
				legend = True

wrapper(main)
