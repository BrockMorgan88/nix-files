#!/usr/bin/env bash

DISK_TOTAL=$(/run/current-system/sw/bin/df | grep ".*/\+$" | awk '{printf "%.2f", $2/1048510}')
DISK_USAGE=$(/run/current-system/sw/bin/df | grep ".*/\+$" | awk '{printf "%.2f", $3/1048510}')
DISK_PERCENT=$(awk '{printf "%.1f", $1*100/$2}' <<< "$DISK_USAGE $DISK_TOTAL")
echo " $DISK_USAGE/$DISK_TOTAL GiB $DISK_PERCENT%"
echo "$DISK_USAGE MiB"
echo "#FFFFFF"