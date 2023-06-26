#!/usr/bin/env python3

# Log program

import json
import sys
from datetime import date
from datetime import datetime, timedelta
import os.path

import signal
import sys

from os.path import expanduser

home = expanduser("~")

def signal_handler(sig, frame):
	print('q')
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)



def add():
	# Get day
	today = date.today()
	now = datetime.now()

	hour = now.strftime("%H")
	day = today.strftime("%d")
	month = today.strftime("%m")
	year = today.strftime("%y")
	if int(hour) < 17:
		yesterday = datetime.now() - timedelta(1)
		day = yesterday.strftime("%d")
		month = yesterday.strftime("%m")
		year = yesterday.strftime("%y")

	# Filename
	fileName = home + "/Programs/output/log/" + year + month + ".json"
	exists = os.path.isfile(fileName)

	if exists:
		currentFile = open(fileName, "r")
		monthString = currentFile.read()
		monthJson = json.loads(monthString)
		currentFile.close()

	# Get info from user
	stuff = input("What Happened Today: ")
	trips = input("Where Were You Today: ")
	video = input("Favourite Video Today: ")
	song = input("Favourite Song Today: ")
	learn = input("What Did You Learn Today: ")

	# Format into JSON
	todayJson = {
	"stuff": stuff,
	"trips": trips,
	"video": video,
	"song": song,
	"learn": learn
	}

	# Add to monthJson
	if not exists:
		monthJson = {day:todayJson}
	else:
		monthJson.update({day: todayJson})

	# Save to file
	with open(fileName, "w") as write_file:
		newJson = json.dump(monthJson, write_file, indent=2)

def search(query, rangeA): # Add functionality to search all entries if rangeA is "0"
	# If the range is only one month, just search that month
	if len(rangeA) == 4:
		searchMonth(rangeA, query)
	# Else search all months in the specified year
	else:
		yearQuery = rangeA[0:2]
		for xy in range(12):
			if xy < 9:
				dateAA = rangeA + "0" + str(xy + 1)
			else:
				dateAA = rangeA + str(xy + 1)
		searchMonth(dateAA, query)


def searchMonth(yM, queryA):
	fileName = home + "/Programs/output/log/" + yM[0:2] + yM[2:4] + ".json"
	exists = os.path.isfile(fileName)
	toReturn = []
	# Open file and get data
	if exists:
		currentFile = open(fileName, "r")
		monthString = currentFile.read()
		monthJson = json.loads(monthString)
		currentFile.close()
		# Extract day data from the dictionary of days
		for key in monthJson:
			#print(key)
			currentDay = monthJson[key]
			#print(currentDay)
			keys = ["stuff", "trips", "video", "song", "learn"]
			# Check for query and if found, add day to array toReturn
			for keyA in keys:
				if queryA.lower() in currentDay[keyA].lower():
					toReturn.append(yM + key)
					
	toReturnNoDupes = list(dict.fromkeys(toReturn))
	# Only print array if it has values
	if len(toReturnNoDupes) > 0:
		toReturnNoDupes.sort()
		print("Present in month " + yM[2:4] + ":")
		for foundDate in toReturnNoDupes:
			print(foundDate[4:6])



def findDay(dayQuery):
	yearFind = dayQuery[0:2]
	monthFind = dayQuery[2:4]
	dayFind = dayQuery[4:6]
	fileName = home + "/Programs/output/log/" + yearFind + monthFind + ".json"
	exists = os.path.isfile(fileName)
	if exists:
		try:
			currentFile = open(fileName, "r")
			monthString = currentFile.read()
			monthJson = json.loads(monthString)
			currentFile.close()
			print("What Happened: \t " + monthJson.get(dayFind).get("stuff"))
			print("Where Were You:  " + monthJson.get(dayFind).get("trips"))
			print("Favourite Video: " + monthJson.get(dayFind).get("video"))
			print("Favourite Song:  " + monthJson.get(dayFind).get("song"))
			print("Learned:  \t " + monthJson.get(dayFind).get("learn"))
		except:
			print("Error, date not present")
	else:
		print("Error, date not present")




def findFavSong(yearA, removeOnes):
	songsDict = {}
	yearExists = False
	for x in range(12):
		x += 1
		if x < 10:
			xString = "0" + str(x)
		else:
			xString = str(x)
		fileName = home + "/Programs/output/log/" + str(yearA) + xString + ".json"
		exists = os.path.isfile(fileName)
		if exists:
			yearExists = True
			currentFile = open(fileName, "r")
			monthString = currentFile.read()
			monthJson = json.loads(monthString)
			currentFile.close()
			#print(monthJson.keys())
			for key in monthJson:
				songName = monthJson.get(key).get("song")
				if songName in songsDict:
					previousNumber = songsDict[songName]
					songsDict.update({songName: previousNumber + 1})
				else:
					songsDict[songName] = 1
	if yearExists:
		songsDict.pop("N/A")
		songsDictSorted = sorted(songsDict.items(), key=lambda x: x[1], reverse=True)

		# Remove entries with only one favourite day
		if removeOnes:
			songsDictSortedRemoved = []
			for item in songsDictSorted:
				if item[1] != 1:
					songsDictSortedRemoved.append(item)
					songsDictSorted = songsDictSortedRemoved

		x = 1
		for key in songsDictSorted:
			print(str(x) + ": " + key[0] + " (" + str(key[1]) + ")")
			x += 1
	else:
		print("Error, year not present")

# Run selected function
if len(sys.argv) == 1:
	add()
elif sys.argv[1] == "-s":
	if len(sys.argv) == 2:
		print("Usage: log -s string [yy/yymm]")
		print("Usage: Type string to search after -s, specify date with yy/yymm format")
	elif len(sys.argv) == 3:
		search(sys.argv[2], "0")
	else:
		search(sys.argv[2], sys.argv[3])
elif sys.argv[1] == "-d":
	if len(sys.argv) == 2:
		print("Usage: log -d yymmdd")
		print("Usage: type date in format yymmdd after -d")
	else:
		findDay(sys.argv[2])
elif sys.argv[1] == "-f":
	if len(sys.argv) == 3:
		findFavSong(sys.argv[2], True)
	else:
		today = date.today()
		year = today.strftime("%y")
		findFavSong(year, True)
elif sys.argv[1] == "-fa":
	if len(sys.argv) == 3:
		findFavSong(sys.argv[2], False)
	else:
		today = date.today()
		year = today.strftime("%y")
		findFavSong(year, False)
else:
	print("Options are: \"log\" to add, \"log -d\" to get date, \"log -s\" to search, \"log -f\" to get favourite song")
