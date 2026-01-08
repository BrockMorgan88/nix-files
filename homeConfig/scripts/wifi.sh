#!/usr/bin/env bash

WIFI_CONN=$(/run/current-system/sw/bin/nmcli device status | grep "wifi" | grep -v "p2p" | awk '{print $3}')
IP=$(/run/current-system/sw/bin/nmcli device show wlp0s20f3 | grep "IP4.ADDRESS" | awk '{print $2}')
SSID=$(/run/current-system/sw/bin/nmcli connection show --active | grep "wifi" | awk '{print $1}')
SPEED=$(/run/current-system/sw/bin/iwlist wlp0s20f3 bitrate | grep "Current" | sed -n -e 's/^.*=//p' | awk '{printf "%.2f MiB/s", $1/8}')
FREQ=$(/run/current-system/sw/bin/iwlist wlp0s20f3 frequency | grep "Current" | sed -n -e 's/^.*://p' | awk '{printf "%.2f GHz", $1}')
UP=$(ip link list | grep "wlp0s20f3" | grep ",UP")
UP_EXISTS=$0
if [ "$WIFI_CONN" = "connected" -a $UP_EXISTS ]; then
    echo " ${IP} ${SSID} ${SPEED} ${FREQ}"
    echo " "
    echo "#00FF00"
elif [ "$WIFI_CONN" = "unavailable" ]; then
    echo "󰖪 󰈅"
    echo "󰖪 󰈅"
    echo "#FF0000"
else
    echo "ERROR"
    echo
    echo "#FF0000"
fi