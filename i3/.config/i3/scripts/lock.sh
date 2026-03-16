#!/bin/bash
# Tokyo Night themed lock screen (requires i3lock-color)

if i3lock --version 2>&1 | grep -qP "\.\bc\b"; then
  i3lock \
    --color=1a1b26 \
    --inside-color=1a1b2600 \
    --ring-color=7aa2f7 \
    --keyhl-color=33ccff \
    --bshl-color=ff9e64 \
    --separator-color=00000000 \
    --insidever-color=7aa2f788 \
    --ringver-color=9ece6a \
    --insidewrong-color=f7768e88 \
    --ringwrong-color=f7768e \
    --line-color=00000000 \
    --time-color=a9b1d6 \
    --date-color=565f89 \
    --clock \
    --indicator \
    --time-str="%H:%M" \
    --date-str="%a %d %b" \
    --time-font="JetBrains Mono Nerd Font" \
    --date-font="JetBrains Mono Nerd Font" \
    --verif-text="..." \
    --wrong-text="!" \
    --noinput-text="" \
    --radius=120 \
    --ring-width=8
else
  # Fallback to plain i3lock
  i3lock --color 1a1b26
fi
