#!/usr/bin/env sh

# Remove mod5 from AltGr
xmodmap -e 'remove mod5 = ISO_Level3_Shift'
# Map it to Super_L
xmodmap -e 'keycode 108 = Super_L'

# ksuperkey has to be launched/restarted after doing this, otherwise it will not recognise AltGr as Super
pkill ksuperkey
ksuperkey
