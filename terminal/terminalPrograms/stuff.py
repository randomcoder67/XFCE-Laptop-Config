#!/usr/bin/env python3

# Program to allow recording of stuff you own

import sys
import os
import pandas as pd
from os.path import expanduser
import signal

def signal_handler(sig, frame):
	print('q')
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

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
def add(indexA):
	# Open file in append mode 
	outputCSV = open(fileName, "a")

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
		hasChildren = input("Has Children (y/N): ")
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
	try:
		chosenLoc = locations[int(chosenLocNum)-1]
	except:
		print("Error, NaN")
		sys.exit(1)
	# Narrow down dataframe by choice
	dfLoc = df[(df["Location"] == chosenLoc)]
	# Get list of specific locations, print and get user choice
	specificLocations = list(dfLoc["SpecificLocation"].drop_duplicates())
	for indexA, locA in enumerate(specificLocations):
		print(str(indexA+1) + ": " + locA)
	print(str(len(specificLocations)+1) + ": All")
	chosenSpeLocNum = input("Which specific location: ")
	# Check if all was chosen
	if int(chosenSpeLocNum) == len(specificLocations) + 1:
		print(dfLoc.to_string())
		return
	# Otherwise check if valid location and print chosen entries
	try:
		chosenSpeLoc = specificLocations[int(chosenSpeLocNum)-1]
	except:
		print("Error, NaN")
		sys.exit(1)
	
	# Narrow down dataframe by choice again and print
	dfFinal = dfLoc[(dfLoc["SpecificLocation"] == chosenSpeLoc)]
	print(dfFinal.to_string())
	

def edit(indexA):
	df = loadDF()
	# Find what you want to edit
	toSearch = input("What do you want to edit: ")
	dfSearch = search(toSearch, False)
	if len(dfSearch) == 0:
		print("No matches")
		sys.exit(0)
	print(dfSearch.to_string())
	# Choose specific item
	indexToChange = int(input("Enter index of item to edit: "))
	# Check if the index was in search results, this it to stop accidentally editing another item because of a typo
	if not indexToChange in dfSearch.index:
		print("Error, index not in search results")
		sys.exit(1)
	# Get the quantity
	quantityToMove = 0
	moreThanOne = False
	# If the quantity is more than one, set necessary variables
	if df.loc[indexToChange, "Quantity"] != "1":
		moreThanOne = True
		quantityToMove = int(input("Enter quantity to edit: "))
		# Check you aren't trying to edit more than exist
		if quantityToMove > int(df.loc[indexToChange, "Quantity"]):
			print("Error, quantity too high")
			sys.exit(1)
	# Choose what to do
	whatToDo = input("Delete or Move? (d/m): ")
	if whatToDo == "m":
		# If quantity is more than one, manage that first
		if moreThanOne:
			# Set the quantity of the original to it's quantity - the number to move
			df.loc[indexToChange, "Quantity"] = int(df.loc[indexToChange, "Quantity"]) - quantityToMove
			# Copy the original
			df.loc[indexA] = df.loc[indexToChange]
			# And set the copy quantity to the number to move
			df.loc[indexA, "Quantity"] = quantityToMove
			# Then set the index being moved to the index of the copy
			indexToChange = indexA
		moveHow = input("Move to new Location or Specific Location? (l/s): ")
		if moveHow == "l":
			newLocation = input("Enter new Location: ")
			df.loc[indexToChange, "Location"] = newLocation
			newSpecificLocation = input("Enter new Specific Location: ")
			df.loc[indexToChange, "SpecificLocation"] = newSpecificLocation
		elif moveHow == "s":
			newSpecificLocation = input("New value: ")
			df.loc[indexToChange, "SpecificLocation"] = newSpecificLocation
		df.to_csv(fileName, sep="|")
	
	# If you want to delete
	elif whatToDo == "d":
		# If the quantity is more than one
		if moreThanOne:
			# If the quantity to delete is all of the items, just delete
			if quantityToMove == int(df.loc[indexToChange, "Quantity"]):
				dfNew = df.drop([indexToChange])
			# Otherwise reduce the quantity and save
			else:
				df.loc[indexToChange, "Quantity"] = int(df.loc[indexToChange, "Quantity"]) - quantityToMove
				df.to_csv(fileName, sep="|")
				return
		else:
			dfNew = df.drop([indexToChange])
		dfNew.to_csv(fileName, sep="|")
		
		

# Parse command line arguments 
if len(sys.argv) > 1:
	if sys.argv[1] == "-h":
		print("Usage:\n  Default - add\n  -e - Edit\n  -s stringToSearch - Search\n  -a - Audit")
	elif sys.argv[1] == "-e":
		edit(indexA)
	elif sys.argv[1] == "-a":
		audit()
	elif sys.argv[1] == "-s":
		if len(sys.argv) == 3:
			search(sys.argv[2], True)
		else:
			print("Usage: stuff.py -s stringToSearch")
else:
	add(indexA)
