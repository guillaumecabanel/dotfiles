#!/usr/bin/env bash
# Display keybindings cheat sheet in rofi

cheatsheet="$HOME/.config/i3/keybindings-cheatsheet.txt"

while IFS='|' read -r key desc; do
    key="${key% }" desc="${desc# }"
    echo "<span bgcolor='#3b3b3b' fgcolor='#e0e0e0' font_weight='bold'> ${key} </span>  ${desc}"
done < "$cheatsheet" | rofi -dmenu -i -p "Keybindings" -no-custom -markup-rows \
    -theme-str 'window {width: 50%;} listview {lines: 15;}'
