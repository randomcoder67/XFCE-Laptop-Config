#!/usr/bin/env python

from bs4 import BeautifulSoup

f = open("blocks.html", "r")
content = f.read()
f.close()

soup = BeautifulSoup(content, "html.parser")

lists = soup.find_all("ul")

listOfBlocks = lists[46]

for block in listOfBlocks.find_all("li"):
	print(block.contents[2].contents[0] + "|" + block.contents[0]["href"])
