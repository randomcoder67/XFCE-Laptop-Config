#!/usr/bin/env bash

# Script to display Intel GPU usage

#output=$(timeout 1 intel_gpu_top -s 1 -J)
#echo "$output" | jq '.engines."Render/3D/0".busy'

output=$(timeout 1 intel_gpu_top -o - -s 500)
#echo "$output"
#echo DONE
echo "$output" | tail -n 1 | tr -s ' ' | cut -d " " -f 8
