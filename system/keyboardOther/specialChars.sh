#!/usr/bin/env sh

# Script to quickly type certain symbols

xdotool keyup Control_L Control_R Shift_L Shift_R Super_R Super_L 1 2 3 4 5 6 7 8 9 0

if [ "$1" == "1" ]; then
	xdotool type ε
elif [ "$1" == "2" ]; then
	xdotool type ∪
elif [ "$1" == "3" ]; then
	xdotool type ¬
elif [ "$1" == "4" ]; then
	xdotool type →
elif [ "$1" == "5" ]; then
	xdotool type ∨
elif [ "$1" == "6" ]; then
	xdotool type ∧
elif [ "$1" == "7" ]; then
	xdotool type ⊢
elif [ "$1" == "8" ]; then
	xdotool type ↔
elif [ "$1" == "9" ]; then
	xdotool type ⊥
elif [ "$1" == "0" ]; then
	xdotool type £
fi
