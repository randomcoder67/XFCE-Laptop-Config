#!/usr/bin/env python3

CHEST_IMAGE = "images/Chest.bmp" # Image of the chest to be displayed in main screen
SPACER_IMAGE = "images/Stone Bricks.bmp" # Image to be used as space in main screen 
CELL_IMAGE = "cell.png" # Background for the chest inventory screen
BLOCK_SIZE=48 # Size of blocks in main screen
CELL_SIZE=72 # Size of cells in chest screen 
GRIDWIDTH = 16

import gi
import interpChestLayout
import cairo
import time
import PIL.Image as Image

def checkForKey(widget, ev):
	if ev.keyval == Gdk.KEY_q:
		Gtk.main_quit()

# Function to convert bmp image to cairo image surface (not mine, source: https://pycairo.readthedocs.io/en/latest/tutorial/pillow.html)
def from_pil(im: Image, alpha: float=1.0, format: cairo.Format=cairo.FORMAT_ARGB32) -> cairo.ImageSurface:
	"""
	:param im: Pillow Image
	:param alpha: 0..1 alpha to add to non-alpha images
	:param format: Pixel format for output surface
	"""
	assert format in (
		cairo.FORMAT_RGB24,
		cairo.FORMAT_ARGB32,
	), f"Unsupported pixel format: {format}"
	if 'A' not in im.getbands():
		im.putalpha(int(alpha * 256.))
	arr = bytearray(im.tobytes('raw', 'BGRa'))
	surface = cairo.ImageSurface.create_for_data(arr, format, im.width, im.height)
	return surface

gi.require_version("Gtk", "3.0")
gi.require_foreign("cairo")
from gi.repository import Gtk, GdkPixbuf, Gdk

def assignToCategory(wid, event, item):
	print(item)

# Function to use cairo to draw chest
def draw_cb(widget, cr):
	#itemImage = GdkPixbuf.Pixbuf.new_from_file("images/Redstone.bmp")
	#itemImage = itemImage.scale_simple(BLOCK_SIZE, BLOCK_SIZE, GdkPixbuf.InterpType.NEAREST)
	
	# Base image (the inventory cell)
	cellImage = cairo.ImageSurface.create_from_png("cell.png")
	cr.scale(4.0, 4.0)
	cr.set_source_surface(cellImage, 0, 0)
	cr.get_source().set_filter(cairo.FILTER_NEAREST)
	cr.paint()
	
	# Item image 
	im = Image.open("images/Redstone.bmp")
	surface2 = from_pil(im, format=cairo.FORMAT_ARGB32)
	cr.set_source_surface(surface2, 1, 1)
	cr.get_source().set_filter(cairo.FILTER_NEAREST)
	#cr.rectangle(0, 0, 64, 64)
	cr.paint()
	cr.fill()
	#Gdk.cairo_set_source_pixbuf(cr, cellImage, 0, 0)
	#return False

itemsDict = {}
f = open("files.csv", "r")
for index, line in enumerate(f.readlines()):
	itemsDict.update({line.split("|")[0]: line.split("|")[1].rstrip()})

# Make grid of images
images = []
for x, y in itemsDict.items():
	pixbufA = GdkPixbuf.Pixbuf.new_from_file("images/" + y)
	pixbufA = pixbufA.scale_simple(64, 64, GdkPixbuf.InterpType.NEAREST)
	imageA = Gtk.Image.new_from_pixbuf(pixbufA)
	eventA = Gtk.EventBox()
	eventA.add(imageA)
	eventA.connect("button-press-event", assignToCategory, (x, y))
	eventA.set_tooltip_text(x)
	images.append(eventA)
	#sys.exit(0)

gridItems = Gtk.Grid()
for index, image in enumerate(images):
	gridItems.attach(image, index%GRIDWIDTH, int(index/GRIDWIDTH), 1, 1)

scrolledItems = Gtk.ScrolledWindow()
scrolledItems.set_vexpand(True)
scrolledItems.set_hexpand(True)
scrolledItems.add(gridItems)


# Makes the chest
def drawChest(window, chestContents, chestCoords):
	gridChest = Gtk.Grid()
	for x in range(9):
		for y in range(6):
			areaA = Gtk.DrawingArea()
			areaA.connect("draw", draw_cb)
			areaA.queue_draw()
			areaA.set_size_request(72, 72)
			print(dir(areaA))
			gridChest.attach(areaA, x, y, 1, 1)
			
			#else:
			#	pixbufA = GdkPixbuf.Pixbuf.new_from_file(CELL_IMAGE)
			#	pixbufA = pixbufA.scale_simple(CELL_SIZE, CELL_SIZE, GdkPixbuf.InterpType.NEAREST)
			#	imageA = Gtk.Image.new_from_pixbuf(pixbufA)
			#	gridChest.attach(imageA, x, y, 1, 1)
	# Remove window child and add gridChest
	childA = window.get_children()
	window.remove(childA[0])
	masterChestGrid = Gtk.Grid()
	masterChestGrid.attach(gridChest, 0, 0, 1, 1)
	masterChestGrid.attach(scrolledItems, 1, 0, 1, 1)
	window.add(masterChestGrid)
	window.show_all()

# Callback function for when you click on a chest
def openChest(wid, event, coords):
	print(coords[0], coords[1])
	window = wid.get_parent().get_parent()
	drawChest(window, [], coords)

layout = interpChestLayout.getLayout()

# The grid on the main page 
gridMaster = Gtk.Grid()

for lineIndex, line in enumerate(layout):
	for positionIndex, position in enumerate(line):
		if position == "c": # If it's a chest 
			pixbufA = GdkPixbuf.Pixbuf.new_from_file(CHEST_IMAGE)
			pixbufA = pixbufA.scale_simple(BLOCK_SIZE, BLOCK_SIZE, GdkPixbuf.InterpType.NEAREST)
			imageA = Gtk.Image.new_from_pixbuf(pixbufA)
			eventA = Gtk.EventBox()
			eventA.add(imageA)
			eventA.connect("button-press-event", openChest, (positionIndex, lineIndex))
			gridMaster.attach(eventA, positionIndex, lineIndex, 1, 1)
		elif position == "s": # If it's a spacer
			pixbufA = GdkPixbuf.Pixbuf.new_from_file(SPACER_IMAGE)
			pixbufA = pixbufA.scale_simple(BLOCK_SIZE, BLOCK_SIZE, GdkPixbuf.InterpType.NEAREST)
			imageA = Gtk.Image.new_from_pixbuf(pixbufA)
			gridMaster.attach(imageA, positionIndex, lineIndex, 1, 1)
		elif position == "e" or "n": # If it's empty
			labelA = Gtk.Label(label = "")
			labelA.set_size_request(BLOCK_SIZE, BLOCK_SIZE)
			gridMaster.attach(labelA, positionIndex, lineIndex, 1, 1)

#gridMaster.set_column_homogeneous(True)
#gridMaster.set_row_homogeneous(True)
win = Gtk.Window()
win.add(gridMaster)
win.set_default_size(300, 300)
win.connect("key-press-event", checkForKey)
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
