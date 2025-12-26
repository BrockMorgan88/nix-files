#!/usr/bin/env bash

ETHERNET_CONN=$(nmcli device status | grep "ethernet" | awk '{print $3}')

if [ "$ETHERNET_CONN" = "unavailable" ]; then
    echo "󰈀 󰈅"
    echo
    echo "#FF0000"
elif [ "$ETHERNET_CONN" = "connected" ]; then
    echo "󰈀 "
    echo
    echo "#00FF00"
else
    echo "ERROR"
fi
return 0