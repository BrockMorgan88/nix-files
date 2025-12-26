#!/usr/bin/env bash

WIFI_CONN=$(nmcli device status | grep "wifi" | grep -v "p2p" | awk '{print $3}')

if [ "$WIFI_CONN" = "unavailable" ]; then
    echo "󰖪 󰈅"
    echo
    echo "#FF0000"
elif [ "$WIFI_CONN" = "connected" ]; then
    echo " "
    echo
    echo "#00FF00"
else
    echo "ERROR"
fi
return 0