#!/usr/bin/env python3

# Extracts Destiny livestream url from rumble

from bs4 import BeautifulSoup
import requests
from os.path import expanduser

home = expanduser("~")

# Open latest downloaded page 
f = open(home + "/Programs/output/.streams/destinyDownload/destinyrumble.html", "r")
html_doc = f.read()

soup = BeautifulSoup(html_doc, 'html.parser')
# Extract links
links = []
for link in soup.find_all('a'):
	links.append(link.get('href'))

# Url of current livestream is the first link
urlEnd = links[0]
fullURL = "https://rumble.com" + urlEnd
print(fullURL)
