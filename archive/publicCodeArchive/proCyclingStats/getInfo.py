#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup
from countryDict import countries
import curses
from curses import wrapper
import sys
import time

stuff = ""

if len(sys.argv) == 1:
	refreshInterval = 10
else:
	refreshInterval = int(sys.argv[1])

colours = {
	"red": "\033[31m",
	"blue": "\033[34m",
	"yellow": "\033[33m",
	"cyan": "\033[36m",
	"magenta": "\033[35m",
	"green": "\033[32m",
	"end": "\033[0m"
}

url = "https://www.procyclingstats.com/race/tour-of-slovenia/2023/stage-5/live"

urlHome = "https://www.procyclingstats.com"

home = requests.get(urlHome)

soup = BeautifulSoup(home.text, "html.parser")

target = soup.find("h3", string="LiveStats")
liveRaces = target.find_next_sibling()

links = liveRaces.find_all("a", href=True)

options = []

for i, link in enumerate(links):
	hyperlink = link["href"]
	title = link.find("div", class_="racename").text
	if "FINISHED" in title:
		continue
	print(f"{i+1}: {title}")
	options.append(hyperlink)

choice = input("Enter choice: ")
url = "https://www.procyclingstats.com/" + options[int(choice)-1]
print(url)

def main(cursesScreen):
	global stuff
	counter = 1
	while True:
		curses.curs_set(0)
		cursesScreen.nodelay(True)
		response = requests.get(url)
		
		curses.init_pair(1, curses.COLOR_RED, curses.COLOR_BLACK)
		curses.init_pair(2, curses.COLOR_GREEN, curses.COLOR_BLACK)
		curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)
		curses.init_pair(4, curses.COLOR_BLUE, curses.COLOR_BLACK)
		curses.init_pair(5, curses.COLOR_MAGENTA, curses.COLOR_BLACK)
		curses.init_pair(6, curses.COLOR_CYAN, curses.COLOR_BLACK)
		RED = curses.color_pair(1)
		GREEN = curses.color_pair(2)
		YELLOW = curses.color_pair(3)
		BLUE = curses.color_pair(4)
		MAGENTA = curses.color_pair(5)
		CYAN = curses.color_pair(6)
		soup = BeautifulSoup(response.text, "html.parser")

		#f = open("output.html", "r")
		#soup = BeautifulSoup(f.read(), "html.parser")
		#f.close()

		uLists = soup.find_all("ul")

		raceStats = uLists[13]

		listElements = raceStats.find_all("li")

		stageStats = []

		for i, element in enumerate(listElements):
			stuff = listElements
			stageStats.append(element.find_all("div")[1].text)
			if i == 4:
				break

		cursesScreen.addstr(1, 1, "Completed:\t ", YELLOW)
		cursesScreen.addstr(stageStats[2] + "KM", RED)
		cursesScreen.addstr(2, 1, "Remaining:\t ", YELLOW)
		cursesScreen.addstr(stageStats[0] + "KM", CYAN)
		cursesScreen.addstr(3, 1, "Time:\t\t ", YELLOW)
		cursesScreen.addstr(stageStats[1], MAGENTA)
		cursesScreen.addstr(4, 1, "Average Speed:\t ", YELLOW)
		cursesScreen.addstr(stageStats[3] + "KM/H", GREEN)
		cursesScreen.addstr(5, 1, "Start Time:\t ", YELLOW)
		cursesScreen.addstr(stageStats[4], BLUE)

		situation = soup.find("ul", class_="situ3")
		riderCont = situation.find_all("div", class_="riderCont")
		lengthA = len(riderCont)
		globalIndex = 7

		for i, x in enumerate(riderCont):			
			timeGap = ""
			if not i == 0:
				timeGap = f"@{x.find('span', class_='time').text}"
				timeGap = timeGap.replace("+", " ").replace("??", "")
			
			if i == 0:
				cursesScreen.addstr(globalIndex, 1, "Breakaway")
			elif not i == lengthA-1:
				cursesScreen.addstr(globalIndex, 1, "Poursulvant (")
				cursesScreen.addstr(timeGap, MAGENTA)
				cursesScreen.addstr(")")
			else:
				cursesScreen.addstr(globalIndex, 1, "Peleton (")
				cursesScreen.addstr(timeGap, MAGENTA)
				cursesScreen.addstr(")")
			
			globalIndex += 1
			
			table = x.find("table")
			rows = table.find_all("tr")
			riders = []
			
			for row in rows:
				cols = row.find_all("td")
				#cols = [ele.text.strip() for ele in cols]
				riders.append([ele for ele in cols if ele])
			
			for rider in riders:
				cursesScreen.addstr(globalIndex, 1, rider[0].text, RED)
				cursesScreen.addstr(". ")
				cursesScreen.addstr(rider[3].text, GREEN)
				cursesScreen.addstr(globalIndex, 30, " (")
				cursesScreen.addstr(rider[2].text, BLUE)
				cursesScreen.addstr(") ")
				cursesScreen.addstr(globalIndex, 38, "(")
				cursesScreen.addstr(rider[1].span['title'], CYAN)
				cursesScreen.addstr(") ")
				cursesScreen.addstr(globalIndex, 80, "(")
				cursesScreen.addstr(countries.get(rider[5].span['class'][2].upper(), 'ERROR'), MAGENTA)
				cursesScreen.addstr(")")
				cursesScreen.addstr(str(counter))
				
				globalIndex += 1
			globalIndex += 1
		try:
			ch = cursesScreen.getch()
		except:
			ch = "NONE"
			print("a")
		if ch == ord("q"):
			break
		counter += 1
		time.sleep(refreshInterval)

try:
	wrapper(main)
except:
	print("here")
	print(stuff)
