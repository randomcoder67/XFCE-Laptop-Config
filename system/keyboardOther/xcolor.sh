#!/usr/bin/env sh

# Script to pick colour and output to notify-send and clipboard

xcolor | tr -d '\n' | tee >(xargs notify-send) | tr -d '#' | xclip -selection c
