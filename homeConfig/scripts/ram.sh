#!/usr/bin/env bash

MEM_TOTAL=$(($(cat /proc/meminfo | awk '{print $2}' | head -1)/1024))
MEM_USAGE=$(($(cat /proc/meminfo | awk '{print $2}' | head -2 | tail -1)/1024))
MEM_PERCENT=$(($MEM_USAGE*100/$MEM_TOTAL))
echo "  $MEM_USAGE/$MEM_TOTAL MiB $MEM_PERCENT%"
echo "$MEM_USAGE MiB"

if [ $MEM_PERCENT -gt 90 ]; then
    COLOUR="#FF0000"
else
    COLOUR="#FFFFFF"
fi

echo "$COLOUR"

return 0