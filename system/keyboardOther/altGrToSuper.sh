#!/usr/bin/env bash

xmodmap -e 'remove mod5 = ISO_Level3_Shift'
xmodmap -e 'keycode 108 = Super_L'

ksuperkey
