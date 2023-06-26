#!/usr/bin/env python3

# Program to allow recording of stuff you own

import sys
import os
import pandas as pd
from os.path import expanduser

home = expanduser("~")
fileName = home + "/Programs/output/updated/stuff.csv"

# Get last index of file to ensure indexes are correct
exists = os.path.isfile(fileName)
indexA = 0
if exists:
	# Get the last line and read the index to find the next index to use
	f = open(fileName, "r")
	lastLine = ""
	for x in f.readlines():
		lastLine = x
	indexA = int(lastLine.split("|")[0])
	f.close()
	indexA += 1
else:
	# If the file doesn't exist, write the header
	f = open(fileName, "w")
	f.write("Index|Location|SpecificLocation|Name|SpecificName|Type|Quantity|Parent\n")
	f.close()

# Add new items to list 
def add():
	# Open file in append mode 
	outputCSV = open("stuff.csv", "a")

	# Ask for location and specific location, this is only done once to prevent typing the same thing multiple times 
	locationA = input("Location: ")
	specificLocationA = input("Specific Location: ")

	while True:
		nameA = input("Simple Name: ")
		# Exits if "q" or "exit" typed 
		if nameA == "q" or nameA == "exit":
			break
		detailedNameA = input("Detailed Name: ")
		typeA = input("Type: ")
		quantityA = input("Quantity: ")
		hasChildren = input("Has Children (y/n): ")
		if quantityA == "":
			quantityA = "1"
		outputCSV.write(str(indexA) + "|" + locationA + "|" + specificLocationA + "|" + nameA + "|" + detailedNameA + "|" + typeA + "|" + quantityA + "|NONE\n") 
		parentIndex = indexA
		indexA += 1
		# For children, the final column is set to the index of the parent 
		if hasChildren == "y":
			while True:
				nameA = input("Simple Name: ")
				if nameA == "q" or nameA == "exit":
					break
				detailedNameA = input("Detailed Name: ")
				typeA = input("Type: ")
				quantityA = input("Quantity: ")
				if quantityA == "":
					quantityA = "1"
				outputCSV.write(str(indexA) + "|" + locationA + "|" + specificLocationA + "|" + nameA + "|" + detailedNameA + "|" + typeA + "|" + quantityA + "|" + str(parentIndex) + "\n")
				indexA += 1

	# Close file 
	outputCSV.close()

def loadDF():
	df = pd.read_csv(fileName, sep="|")
	df = df.set_index("Index")
	return df


def search(stringToSearch, toPrint):
	df = loadDF()
	dfMatches = df[(df["Name"].str.contains(stringToSearch, case=False)) | (df["SpecificName"].str.contains(stringToSearch, case=False)) | (df["Type"].str.contains(stringToSearch, case=False))]
	if toPrint:
		print(dfMatches.to_string())
	else:
		return(dfMatches)


def audit():
	df = loadDF()
	# Get list of locations, print and get user choice
	locations = list(df["Location"].drop_duplicates())
	for index, loc in enumerate(locations):
		print(str(index+1) + ": " + loc)
	chosenLocNum = input("Which location: ")
	chosenLoc = locations[int(chosenLocNum)-1]
	
	# Narrow down dataframe by choice
	dfLoc = df[(df["Location"] == chosenLoc)]
	# Get list of specific locations, print and get user choice
	specificLocations = list(dfLoc["SpecificLocation"].drop_duplicates())
	for indexA, locA in enumerate(specificLocations):
		print(str(indexA+1) + ": " + locA)
	chosenSpeLocNum = input("Which specific location: ")
	chosenSpeLoc = specificLocations[int(chosenSpeLocNum)-1]
	
	# Narrow down dataframe by choice again
	dfFinal = dfLoc[(dfLoc["SpecificLocation"] == chosenSpeLoc)]
	# Print
	print(dfFinal.to_string())
	

def edit():
	df = loadDF()
	# Find what you want to edit
	toSearch = input("What do you want to edit: ")
	dfSearch = search(toSearch, False)
	print(dfSearch.to_string())
	# Choose specific item
	indexToChange = int(input("Enter index of item to edit: "))
	# Choose what to do
	whatToDo = input("Delete or Move? (d/m): ")
	if whatToDo == "m":
		moveHow = input("Move to new Location or Specific Location? (l/s): ")
		moveWhere = input("New value: ")
		if moveHow == "l":
			df.loc[indexToChange, "Location"] = moveWhere
		elif moveHow ==	 "s":
			df.loc[indexToChange, "SpecificLocation"] = moveWhere
		#print(df.to_string())
		df.to_csv(fileName, sep="|")
		
	elif whatToDo == "d":
		dfNew = df.drop([indexToChange])
		#print(dfNew.to_string())
		dfNew.to_csv(fileName, sep="|")
		
		

# Parse command line arguments 
if len(sys.argv) > 1:
	if sys.argv[1] == "-h":
		print("Usage:\n  Default - add\n  -e - Edit\n  -s stringToSearch - Search\n  -a - Audit")
	elif sys.argv[1] == "-e":
		edit()
	elif sys.argv[1] == "-a":
		audit()
	elif sys.argv[1] == "-s":
		if len(sys.argv) == 3:
			search(sys.argv[2], True)
		else:
			print("Usage: stuff.py -s stringToSearch")
	else:
		add()
