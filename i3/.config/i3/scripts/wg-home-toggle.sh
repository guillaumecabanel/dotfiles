#!/bin/bash

if ip link show wg-home &>/dev/null; then
    sudo wg-quick down wg-home
else
    sudo wg-quick up wg-home
fi

pkill -SIGRTMIN+2 i3blocks
