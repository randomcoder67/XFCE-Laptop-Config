#!/usr/bin/env bash

# Script to display system usage information in Rofi script

cat "$HOME/Programs/configure/README.md" | grep "\`" | rofi -dmenu -i -p "System Usage Information"
