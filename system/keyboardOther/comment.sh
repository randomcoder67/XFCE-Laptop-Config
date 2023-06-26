#!/usr/bin/env bash

# Program to comment and uncomment code

textInput=$(xclip -o)

outputA="${textInput//$'\n'/$'\n'#}"

notify-send "$outputA"

echo "#$outputA" | xclip -sel clip


xdotool keyup Control_L Control_R Shift_L Shift_R Super_R Super_L

xdotool key ctrl+v
