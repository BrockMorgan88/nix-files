#!/usr/bin/env bash

CPU_USAGE=$(mpstat -u | awk '{print $3}' | tail -1)
CPU_TEMP=$(sensors | grep "Core 8:" | awk '{print $3}')

echo "  $CPU_USAGE% $CPU_TEMP"
echo

if [ $(awk '{print $1*$2}' <<< "${CPU_USAGE} 100") -gt 9000 ]; then
    echo "#FF0000"
else
    echo "#FFFFFF"
fi