#!/usr/bin/env python3

GRIDWIDTH = 16
SAVE_FILENAME = "save.json"

import gi
import sys
import json

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GdkPixbuf, Gdk

mainDict = {}
buildingDict = {}
coloredDict = {}
naturalDict = {}
functionalDict = {}
redstoneDict = {}
toolsDict = {}
combatDict = {}
foodDict = {}
ingredientsDict = {}

try:
	f = open(SAVE_FILENAME, "r")
	itemsJSON = json.loads(f.read())
	mainDict = itemsJSON["main"]
	buildingDict = itemsJSON["building"]
	coloredDict = itemsJSON["colored"]
	naturalDict = itemsJSON["natural"]
	functionalDict = itemsJSON["functional"]
	redstoneDict = itemsJSON["redstone"]
	toolsDict = itemsJSON["tools"]
	combatDict = itemsJSON["combat"]
	foodDict = itemsJSON["food"]
	ingredientsDict = itemsJSON["ingredients"]
	f.close()
except:
	f = open("files.csv", "r")
	for index, line in enumerate(f.readlines()):
		mainDict.update({line.split("|")[0]: line.split("|")[1].rstrip()})
	f.close()

allDicts = [mainDict, buildingDict, coloredDict, naturalDict, functionalDict, redstoneDict, toolsDict, combatDict, foodDict, ingredientsDict]
categoryNames = ["Main", "Building Blocks", "Colored Blocks", "Natural Blocks", "Functional Blocks", "Redstone Blocks", "Tools & Utilities", "Combat", "Food & Drinks", "Ingredients"]
categoryGrids = []

currentCategory = "Building Blocks"

# Make grid of images

def dictFromCategory(category):
	for index, item in enumerate(categoryNames):
		if item == category:
			return allDicts[index]
	return {}

stack = Gtk.Stack()
win = Gtk.Window()

def assignToCategory(wid, event, name):
	print(currentCategory)
	if currentCategory == stack.get_visible_child_name():
		newDict = dictFromCategory("Main")
		newDict.update({name[0]: name[1]})
		currentDict = dictFromCategory(stack.get_visible_child_name())
		currentDict.pop(name[0])
	else:
		newDict = dictFromCategory(currentCategory)
		newDict.update({name[0]: name[1]})
		currentDict = dictFromCategory(stack.get_visible_child_name())
		currentDict.pop(name[0])
	makeScrolled()
	win.show_all()

scrolledDict = {}
for index, x in enumerate(categoryNames):
	scrolledA = Gtk.ScrolledWindow()
	stack.add_titled(scrolledA, categoryNames[index], categoryNames[index])
	scrolledDict.update({x: scrolledA})
	
firstGo = True

images = {}

for index, dictA in enumerate(allDicts):
	for x, y in dictA.items():
		pixbufA = GdkPixbuf.Pixbuf.new_from_file("images/" + y)
		pixbufA = pixbufA.scale_simple(64, 64, GdkPixbuf.InterpType.NEAREST)
		imageA = Gtk.Image.new_from_pixbuf(pixbufA)
		eventA = Gtk.EventBox()
		eventA.add(imageA)
		eventA.connect("button-press-event", assignToCategory, (x, y))
		eventA.set_tooltip_text(x)
		images.update({x: eventA})

#print(images)
def makeScrolled():
	global firstGo
	for index, x in enumerate(scrolledDict):
		scrolledB = scrolledDict[x]
		if not firstGo:
			oldGrid = scrolledB.get_children()[0].get_children()[0]
			for x in oldGrid.get_children():
				oldGrid.remove(x)
			scrolledB.remove(oldGrid)
	for index, x in enumerate(scrolledDict):
		scrolledB = scrolledDict[x]
		gridA = Gtk.Grid()
		i = 0
		x = allDicts[index]
		for y, z in x.items():
			gridA.attach(images[y], i%GRIDWIDTH, int(i/GRIDWIDTH), 1, 1)
			i += 1
		#if not firstGo:
		#	scrolledB.remove(scrolledB.get_children()[0].get_children()[0])
		scrolledB.add(gridA)
		scrolledB.set_vexpand(True)
		scrolledB.set_hexpand(True)
	firstGo = False

makeScrolled()
gridMain = Gtk.Grid()
stackSwitcher = Gtk.StackSwitcher()

stackSwitcher.set_stack(stack)
stackSwitcher.set_orientation(Gtk.Orientation.VERTICAL)

def changeCategory(button, name):
	if button.get_active():
		global currentCategory
		currentCategory = name	

button1 = Gtk.RadioButton.new_with_label_from_widget(None, "Building Blocks")
button1.connect("toggled", changeCategory, "Building Blocks")
button2 = Gtk.RadioButton.new_with_label_from_widget(button1, "Colored Blocks")
button2.connect("toggled", changeCategory, "Colored Blocks")
button3 = Gtk.RadioButton.new_with_label_from_widget(button1, "Natural Blocks")
button3.connect("toggled", changeCategory, "Natural Blocks")
button4 = Gtk.RadioButton.new_with_label_from_widget(button1, "Functional Blocks")
button4.connect("toggled", changeCategory, "Functional Blocks")
button5 = Gtk.RadioButton.new_with_label_from_widget(button1, "Redstone Blocks")
button5.connect("toggled", changeCategory, "Redstone Blocks")
button6 = Gtk.RadioButton.new_with_label_from_widget(button1, "Tools & Utilities")
button6.connect("toggled", changeCategory, "Tools & Utilities")
button7 = Gtk.RadioButton.new_with_label_from_widget(button1, "Combat")
button7.connect("toggled", changeCategory, "Combat")
button8 = Gtk.RadioButton.new_with_label_from_widget(button1, "Food & Drinks")
button8.connect("toggled", changeCategory, "Food & Drinks")
button9 = Gtk.RadioButton.new_with_label_from_widget(button1, "Ingredients")
button9.connect("toggled", changeCategory, "Ingredients")

gridMaster = Gtk.Grid()
gridMaster.attach(button1, 0, 0, 1, 1)
gridMaster.attach(button2, 1, 0, 1, 1)
gridMaster.attach(button3, 2, 0, 1, 1)
gridMaster.attach(button4, 3, 0, 1, 1)
gridMaster.attach(button5, 4, 0, 1, 1)
gridMaster.attach(button6, 5, 0, 1, 1)
gridMaster.attach(button7, 6, 0, 1, 1)
gridMaster.attach(button8, 7, 0, 1, 1)
gridMaster.attach(button9, 8, 0, 1, 1)
gridMaster.attach(stackSwitcher, 0, 1, 1, 1)
gridMaster.attach(stack, 1, 1, 8, 1)

win.add(gridMaster)
win.set_default_size(250, 300)
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()

toSaveJSON = {}
toSaveJSON["main"] = mainDict
toSaveJSON["building"] = buildingDict
toSaveJSON["colored"] = coloredDict
toSaveJSON["natural"] = naturalDict
toSaveJSON["functional"] = functionalDict
toSaveJSON["redstone"] = redstoneDict
toSaveJSON["tools"] = toolsDict
toSaveJSON["combat"] = combatDict
toSaveJSON["food"] = foodDict
toSaveJSON["ingredients"] = ingredientsDict

with open(SAVE_FILENAME, "w") as write_file:
	newJson = json.dump(toSaveJSON, write_file, indent=2)
