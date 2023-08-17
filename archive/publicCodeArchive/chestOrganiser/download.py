#!/usr/bin/env python3

import sys
import requests

f = open(sys.argv[1], "r")
lines = f.readlines()
f.close()

lengthA = len(lines)

for index, line in enumerate(lines):
	print(str(round(((index+1)/lengthA) * 100, 2)) + "%")
	while True:
		try:
			r = requests.get(line.split("|")[1])
			fileName = "files/" + line.split("|")[0] + ".png"
			open(fileName, "wb").write(r.content)
			break
		except:
			continue
