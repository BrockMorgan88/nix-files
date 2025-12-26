#!/usr/bin/env bash

BATTERY_FILE_PATH="/sys/class/power_supply/BAT0/uevent"
BATTERY_STATUS=$(cat "$BATTERY_FILE_PATH" | sed -n -e 's/^.*POWER_SUPPLY_STATUS=//p')
BATTERY_CAPACITY=$(cat "$BATTERY_FILE_PATH" | sed -n -e 's/^.*POWER_SUPPLY_CAPACITY=//p')

if [ "$BATTERY_STATUS" = "Discharging" ]; then
    if [ "$BATTERY_CAPACITY" -lt 10 ]; then
        echo "󰁺 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 20 ]; then
        echo "󰁻 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 30 ]; then
        echo "󰁼 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 40 ]; then
        echo "󰁽 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 50 ]; then
        echo "󰁾 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 60 ]; then
        echo "󰁿 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 70 ]; then
        echo "󰂀 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 80 ]; then
        echo "󰂁 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 90 ]; then
        echo "󰂂 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 100 ]; then
        echo "󰁹 $BATTERY_CAPACITY%"
    fi
elif [ "$BATTERY_STATUS" = "Charging" ]; then
    if [ "$BATTERY_CAPACITY" -lt 10 ]; then
        echo "󰢜 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 20 ]; then
        echo "󰂆 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 30 ]; then
        echo "󰂇 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 40 ]; then
        echo "󰂈 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 50 ]; then
        echo "󰢝 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 60 ]; then
        echo "󰂉 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 70 ]; then
        echo "󰢞 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 80 ]; then
        echo "󰂊 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 90 ]; then
        echo "󰂋 $BATTERY_CAPACITY%"
    elif [ "$BATTERY_CAPACITY" -lt 100 ]; then
        echo "󰂅 $BATTERY_CAPACITY%"
    fi
    echo
    echo "#00FF00"
fi

return 0