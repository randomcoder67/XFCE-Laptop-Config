#!/usr/bin/env python3

# Extracts Destiny livestream url from rumble

from bs4 import BeautifulSoup
import requests
from os.path import expanduser

home = expanduser("~")


f = open(home + "/Programs/output/.streams/destinyDownload/destinyrumble.html", "r")
html_doc = f.read()

soup = BeautifulSoup(html_doc, 'html.parser')
links = []
for link in soup.find_all('a'):
	links.append(link.get('href'))


urlEnd = links[0]
fullURL = "https://rumble.com" + urlEnd
print(fullURL)

#r = requests.get(fullURL)
#html = r.text

#soup = BeautifulSoup(html, 'html.parser')
#for link in soup.find_all('a'):
#	print(link.get('href'))
