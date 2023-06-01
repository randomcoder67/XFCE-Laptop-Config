#!/usr/bin/env bash

# Script to get destiny live stream URL from rumble and pass to mpv

python3 ~/Programs/system/urlExtract.py | xargs mpv
