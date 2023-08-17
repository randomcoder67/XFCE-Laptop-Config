#!/usr/bin/env python3

import os
import sys

files = os.listdir("images/")

f = open(sys.argv[1], "r")
h = open("files.csv", "w")

correctNames = f.readlines()

for name in correctNames:
	name = name.replace(")", "").replace("(", "").rstrip()
	originalName = name
	if name == "Raw Beef":
		name = "Beef"
	elif name == "Raw Chicken":
		name = "Chicken"
	elif name == "Raw Cod":
		name = "Cod"
	elif name == "Raw Mutton":
		name = "Mutton"
	elif name == "Raw Porkchop":
		name = "Porkchop"
	elif name == "Raw Rabbit":
		name = "Rabbit"
	elif name == "Raw Salmon":
		name = "Salmon"
	elif name == "Disc Fragment":
		name = "Disc Fragment 5"
	elif name == "Empty Map":
		name = "Map"
	elif name == "Clock":
		name = "Clock 00"
	elif name == "Compass":
		name = "Compass 16"
	elif name == "Bottle o' Enchanting":
		name = "Experience Bottle"
	elif name == "Recovery Compass":
		name = "Recovery Compass 16"
	elif name == "Crossbow":
		name = "Crossbow Standby"
	elif name == "Explorer Map":
		name = "Map"
	elif name == "Tipped Arrow":
		name = "Spectral Arrow"
	elif name == "Enchanted Golden Apple":
		name = "Golden Apple"
	testFilename = name + ".bmp"
	if not testFilename in files:
		print(testFilename)
	else:
		h.write(originalName + "|" + testFilename + "\n")
		

f.close()
h.close()
