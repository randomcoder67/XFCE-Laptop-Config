#!/usr/bin/env python3

# A simple Python script to monitor network traffic (download)

import time
import signal
import os

def signal_handler(sig, frame):
    print("")
    exit(0)

signal.signal(signal.SIGINT, signal_handler)

def getDownloadFile():
	interfaces = os.listdir("/sys/class/net/")
	downloadFile = "/sys/class/net/"
	for interface in interfaces:
		if interface.startswith("w"):
			downloadFile += interface
			break
	
	downloadFile += "/statistics/rx_bytes"
	
	return downloadFile


def readFile(download_file):
    f = open(downloadFile, "r")
    contents = f.read()
    f.close()
    toReturn = int(contents)
    return toReturn

def run(downloadFile):
	seconds = 0
	initial = readFile(downloadFile)
	totalSinceStart = 0
	oldTotal = initial

	print("Average: 0KiB/s (0KB/s)       ")
	print("Total: 0MiB (0MB)       ")

	while True:
		time.sleep(1)
		seconds = seconds + 1
		newTotal = readFile(downloadFile)

		totalSinceStart = totalSinceStart + (newTotal-oldTotal)

		oldTotal = newTotal

		average = totalSinceStart/seconds
		averageKiB = average/1024
		averageKB = average/1000
		
		totalMiB = ((oldTotal-initial)/1024)/1024
		totalMB = ((oldTotal-initial)/1000)/1000

		print("\033[A", end="\r")
		print("\033[A", end="\r")
		print("Average: " + str(round(averageKiB)) + "KiB/s (" + str(round(averageKB)) + "KB/s)     ")
		print("Total: " + str(round(totalMiB)) + "MiB (" + str(round(totalMB)) + "MB)     ")
    
if __name__ == "__main__":
	downloadFile = getDownloadFile()
	run(downloadFile)
