#!/usr/bin/env bash

MEM_TOTAL=$(($(/run/current-system/sw/bin/free | grep 'Mem' | awk '{print $2}')/1024))
MEM_USAGE=$(($(/run/current-system/sw/bin/free | grep 'Mem' | awk '{print $3}')/1024))
MEM_PERCENT=$(($MEM_USAGE*100/$MEM_TOTAL))
echo "  $MEM_USAGE/$MEM_TOTAL MiB $MEM_PERCENT%"
echo "$MEM_USAGE MiB"

if [ $MEM_PERCENT -gt 90 ]; then
    COLOUR="#FF0000"
else
    COLOUR="#FFFFFF"
fi

echo "$COLOUR"