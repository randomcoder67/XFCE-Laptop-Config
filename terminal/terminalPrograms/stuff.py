#!/usr/bin/env python3

f = open("stuff.csv", "r")
lengthA = len(f.readlines())
f.close()

indexA = 0 + lengthA

outputCSV = open("stuff.csv", "a")

locationA = input("Location: ")
specificLocationA = input("Specific Location: ")

while True:
	nameA = input("Simple Name: ")
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
	
outputCSV.close()
