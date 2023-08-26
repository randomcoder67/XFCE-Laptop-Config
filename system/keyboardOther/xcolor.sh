#!/usr/bin/env sh

xcolor | tr -d '\n' | tee >(xargs notify-send) | tr -d '#' | xclip -selection c
