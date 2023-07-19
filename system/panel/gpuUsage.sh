#!/usr/bin/env bash

# Panel nvidia GPU usage monitor

GPUUSAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -d " %")
if ((GPUUSAGE < 10)); then
	GPUUSAGE="0${GPUUSAGE}%"
else
	GPUUSAGE="${GPUUSAGE}%"
fi

echo "$GPUUSAGE "
