#!/usr/bin/env sh

# Rofi emoji picker

cat "$HOME/Downloads/allEmojis.txt" | rofi -dmenu -i -p "Pick Emoji" | cut -d " " -f 1 | tr -d '\n' | xclip -selection c
