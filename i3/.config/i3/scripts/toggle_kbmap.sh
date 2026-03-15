#!/bin/bash

if setxkbmap -print | grep azerty &>/dev/null; then
    setxkbmap us -option compose:caps
    notify-send " " "qwerty" -t 1500
    touch /tmp/kbmap-qwerty
else
    setxkbmap fr -option compose:caps
    notify-send " " "azerty" -t 1500
    rm /tmp/kbmap-qwerty
fi

pkill -SIGRTMIN+1 i3blocks
