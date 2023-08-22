#!/usr/bin/env python3

import music_tag
import pandas as pd
import os
import json
import sys
import requests
from os.path import expanduser

home = expanduser("~")

def getArt(albumIDA):
	toReturn = []
	try:
		searchString = "https://itunes.apple.com/lookup?id=" + albumIDA + "&entity=song"
		jsonA = requests.get(searchString).json()

		for x in jsonA["results"]:
			try:
				colName = x["collectionName"]
				artwork = x["artworkUrl100"].replace("100x100bb", "1500x1500")
				toReturn.append((colName, artwork))
			except:
				continue
	except:
		print("not a song")
		searchString = "https://itunes.apple.com/lookup?id=" + albumIDA + "&entity=album"
		jsonA = requests.get(searchString).json()

		for x in jsonA["results"]:
			try:
				colName = x["collectionName"]
				artwork = x["artworkUrl100"].replace("100x100bb", "1500x1500")
				toReturn.append((colName, artwork))
			except:
				continue
	return toReturn

def find_nth(haystack, needle, n):
	start = haystack.find(needle)
	while start >= 0 and n > 1:
		start = haystack.find(needle, start+len(needle))
		n -= 1
	return start

if not len(sys.argv) == 3:
	exit()

fileName = sys.argv[1]
albumID = sys.argv[2]

# Get album covers and check which one to use

albumCovers = getArt(albumID)

for index, entry in enumerate(albumCovers):
	print(str(index) + ":")
	print(entry[0])
	print(entry[1])

correctArt = input("Which art to use: ")

correctArtLink = albumCovers[int(correctArt)][1]

# Get other tags from filename 

metadataFileName = home + "/Programs/output/updated/allSongsMetadata.csv"
tempFileName = home + "/Programs/output/.temp/temp.jpg"

f = open(metadataFileName, "a")

fileFormatted = fileName.replace(" - Topic" , "") # Remove "Topic" from filename
albumA = ""
artistA = ""
titleA = ""

# If there are more than 2 - character in the filename, need to ask user where the extra one is
if fileFormatted.count(" - ") > 2:
	print("Which field contains the extra - character? (1 = Title, 2 = Artist, 3 = Album)")
	fieldA = input("Enter number: ")
	if fieldA == "1":
		endOfTitle = find_nth(fileFormatted, " - ", 2)
		titleA = fileFormatted[:endOfTitle]
		splitA = fileFormatted.split(" - ")
		artistA = splitA[2]
		albumA = splitA[3]
	elif fieldA == "2":
		firstIndex = fileFormatted.find(" - ")
		lastIndex = fileFormatted.rfind(" - ")
		splitA = fileFormatted.split(" - ")
		titleA = splitA[0]
		artistA = fileFormatted[firstIndex+3:lastIndex]
		albumA = splitA[len(splitA)-1]
	elif fieldA == "3":
		splitA = fileFormatted.split(" - ")
		titleA = splitA[0]
		artistA = splitA[1]
		endOfArtist = find_nth(fileFormatted, " - ", 2)
		albumA = fileFormatted[endOfArtist+3:]

else:
	splitFile = fileFormatted.split(" - ")
	titleA = splitFile[0]
	albumA = splitFile[len(splitFile)-1]
	artistA = splitFile[1]

titleB = titleA.replace("  ", " ")
artistB = artistA.replace("  ", " ")
albumB = albumA.replace(".m4a", "")
albumC = albumB.replace("  ", " ")

genreName = input("Enter Genre: ")

f.write(fileName + "|" + titleB + "|" + artistB + "|" + albumC + "|" + correctArtLink + "|" + genreName + "\n")
f.close()

def doTagging(fileA, titleA, artistA, albumA, artLinkA, genreA):
	try:
		r = requests.get(artLinkA)
		if artLinkA == "BLANKENTRY":
			raise Exception("Blank Entry")

		currentFile = music_tag.load_file(fileA)
		currentFile["title"] = titleA
		currentFile["artist"] = artistA
		currentFile["album"] = albumA
		currentFile["genre"] = genreA

		open(tempFileName, "wb").write(r.content)

		with open(tempFileName, "rb") as img_in:
			currentFile["artwork"] = img_in.read()

		currentFile.save()

		return True
	except Exception as e:
		return False

if doTagging(fileName, titleB, artistB, albumB, correctArtLink, genreName):
	print("Success")
else:
	print("Error, tags not completed")
