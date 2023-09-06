#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import json

r = requests.get('https://www.bbc.co.uk/weather/2643825')

soup=BeautifulSoup(r.text,"html.parser")
item=soup.select_one('script[data-state-id="forecast"]').text
jsondata=json.loads(item)
print(json.dumps(jsondata, indent=2, sort_keys=True))
