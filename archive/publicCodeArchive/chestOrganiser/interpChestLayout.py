#!/usr/bin/env python3

def getLayout():
	f = open("layout.txt", "r")
	lines = f.readlines()
	f.close()

	layout = []
	for line in lines:
		lineList = []
		for position in [*line]:
			if not position == "\n":
				if position == "":
					position = "n"
				lineList.append(position)
		layout.append(lineList)
		
	return layout
