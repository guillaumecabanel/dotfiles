#!/bin/bash

brightnessctl set $1
VALUE=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
notify-send "Brightness" "" -h int:value:"$VALUE" -t 1500 -r 9991
