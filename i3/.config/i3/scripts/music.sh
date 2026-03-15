#!/bin/bash

TMPDIR="/tmp"
LOFI_URL="https://1a-1791.com/live/nd3n15l5/slot-46/9erd-mia5/chunklist.m3u8"
RADIO_SYMPA_URL="https://radio11.pro-fhi.net/flux-aryfnfye2/stream"

case "$1" in
  lofi)
    pkill vlc 2>/dev/null
    rm -f "$TMPDIR"/music_*
    touch "$TMPDIR/music_lofi"
    cvlc -d --no-video $LOFI_URL
    notify-send "Radio" "Lofi" -t 1500
    pkill -SIGRTMIN+4 i3blocks
    pkill -SIGRTMIN+5 i3blocks
    ;;
  radio_sympa)
    pkill vlc 2>/dev/null
    rm -f "$TMPDIR"/music_*
    touch "$TMPDIR/music_radio_sympa"
    cvlc -d $RADIO_SYMPA_URL
    notify-send "Radio" "Sympa" -t 1500
    pkill -SIGRTMIN+4 i3blocks
    pkill -SIGRTMIN+5 i3blocks
    ;;
  stop)
    pkill vlc 2>/dev/null
    rm -f "$TMPDIR"/music_*
    notify-send "Radio" "Off" -t 1500
    pkill -SIGRTMIN+4 i3blocks
    pkill -SIGRTMIN+5 i3blocks
    ;;
  *)
    echo "Usage: $0 {lofi|radio_sympa|stop}"
    exit 1
    ;;
esac
