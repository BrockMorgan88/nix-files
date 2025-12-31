#!/usr/bin/env bash

BATTERY_FILE_PATH="/sys/class/power_supply/BAT0/uevent"
BATTERY_STATUS=$(cat "$BATTERY_FILE_PATH" | sed -n -e 's/^.*POWER_SUPPLY_STATUS=//p')
BATTERY_CAPACITY=$(cat "$BATTERY_FILE_PATH" | sed -n -e 's/^.*POWER_SUPPLY_CAPACITY=//p')
COLOUR="#FFFFFF"

if [ "$BATTERY_STATUS" = "Discharging" ]; then
    if [ "$BATTERY_CAPACITY" -lt 10 ]; then
        notify-send --urgency=critical --app-name=i3blocks "BATTERY LOW" "Plug in your battery now!"
        echo "󰁺 $BATTERY_CAPACITY%"
        COLOUR="#FF0000"
    elif [ "$BATTERY_CAPACITY" -lt 20 ]; then
        echo "󰁻 $BATTERY_CAPACITY%"
        COLOUR="#FF0000"
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
    else
        echo "󰁹 $BATTERY_CAPACITY%"
    fi
elif [ "$BATTERY_STATUS" = "Charging" ]; then
    COLOUR="#00FF00"
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
    else
        echo "󰂅 $BATTERY_CAPACITY%"
    fi
fi

echo "$BATTERY_CAPACITY"
echo "$COLOUR"

return 0