#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import sys
from os.path import expanduser

home = expanduser("~")

urlA = "https://www.strava.com/segments/" + sys.argv[1] + "?filter=overall"
response = requests.get(urlA)

htmlText = response.text
soup = BeautifulSoup(htmlText, "html.parser")

data = []

table = soup.find("table")
table_body = table.find("tbody")
rows = table_body.find_all("tr")

for row in rows:
	cols = row.find_all("td")
	cols = [ele.text.strip() for ele in cols]
	data.append([ele for ele in cols if ele])
	
for indexLine, line in enumerate(data):
	for indexItem, item in enumerate(line):
		data[indexLine][indexItem] = item.replace("\nPower Meter", "")
		
fileName = home + "/Programs/output/.temp/table.md"

markdownFile = open(fileName, "w")
markdownFile.write("# Segment Leaderboard\n")
markdownFile.write("| Rank | Name | Speed | Power | Time |\n")
markdownFile.write("| :--: | :--: | :--: | :--: | :--: |\n")

for x in data:
	timeSplit = x[4].split(":")
	timeMins = str(timeSplit[0])
	if len(timeSplit) == 2:
		if len(timeMins) == 1:
			timeMins = "0" + timeMins
		timeSecs = timeSplit[1]
	else:
		timeSecs = str(x[4][0:2])
		timeMins = "00"
	
	#print(timeMins, timeSecs)

	rankNum = str(x[0])
	if len(rankNum) == 1:
		rankNum = "0" + rankNum
	markdownFile.write("| No. " + rankNum + " | " + x[1] + " | " + x[2] + " | " + x[3] + " | " + "00:" + timeMins + ":" + timeSecs + " |\n")

markdownFile.close()
