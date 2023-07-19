#!/usr/bin/env bash

# Panel nvidia VRAM usage monitor

GPUMEM=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | tr -d "MiB")

if ((GPUMEM < 9951)); then
	GPUMEM=$(echo "$GPUMEM" | awk '{ final=$1/1000; printf"%0.1f", final }')
	GPUMEM="${GPUMEM} GB"
else
	GPUMEM=$(echo "$GPUMEM" | awk '{ final=$1/1000; printf"%0.0f", final }')
	GPUMEM="${GPUMEM} GB"
fi

echo "$GPUMEM "
