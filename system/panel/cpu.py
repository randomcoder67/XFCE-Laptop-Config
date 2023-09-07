#!/usr/bin/env python3

# Panel CPU usage monitor

import pickle
import time
import subprocess
import os
from os.path import expanduser

home = expanduser("~")

filename = home + '/Programs/output/.temp/mypickle.pk'

if not os.path.exists(filename):
	with open(filename, 'wb') as fi:
		savedValues=[1,2]
		# dump your data into the file
		pickle.dump(savedValues, fi)

with open(filename, 'rb') as fi:
	savedValues = pickle.load(fi)


#print(savedValues[0])
previousTotal = int(savedValues[0])
previousIdle = int(savedValues[1])
#print(previousIdle)

def doThing():
	f = open("/proc/stat", "r")
	result = f.readline().strip('\n').strip()
	#print(result)
	name, notNeeded, user, nice, system, idle, iowait, irq, softirq, steal, _, _ = result.split(" ")

	#commandString = "grep ^cpu. /proc/stat | head -n 1"
	#handle = subprocess.check_output(['grep', '^cpu.', '/proc/stat'])
	#local handle = io.popen("grep ^cpu. /proc/stat | head -n 1")
	#local result = handle:read("*a")
	#handle:close()
	#local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
	#result:match('(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

	total = int(user) + int(nice) + int(system) + int(idle) + int(iowait) + int(irq) + int(softirq) + int(steal)
	total = int(total)
	idle = int(idle)
	#print(previousIdle)
	#print(total)
	totalA = total - previousTotal
	idleA = idle - previousIdle
	#previousTotal = total
	#previousIdle = idle
	fraction = idleA/totalA
	usage = 1-fraction
	percentage = usage*100
	percentageR = 0
	if percentage < 9.995:
		percentageR = round(percentage, 2)
		percentageR = '{0:.2f}'.format(percentageR)
	else:
		percentageR = round(percentage, 1)
		percentageR = '{0:.1f}'.format(percentageR)

	#if percentage < 10:
	# percentageR = round2(percentage)
	#else:
	# percentageR = round1(percentage)

	toSetA = str(percentageR) + "%"
	savedValues[0] = total
	savedValues[1] = idle
	print(toSetA + " ")


doThing()

#time.sleep(1)
#doThing()
#time.sleep(1)
#doThing()



with open(filename, 'wb') as fi:
	# dump your data into the file
	pickle.dump(savedValues, fi)
