#!/usr/bin/env bash

# Panel nvidia GPU temperature monitor

GPUTEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | sed 's/$/°C/')
echo "$GPUTEMP "
