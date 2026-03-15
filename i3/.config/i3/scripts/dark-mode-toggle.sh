#!/bin/bash
STATE_FILE="$HOME/.config/i3/.theme"

CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [ "$CURRENT" = "dark" ]; then
    NEW="light"
    GTK_DARK=0
    GSETTINGS_SCHEME="prefer-light"
    GSETTINGS_THEME="Adwaita"
    IDE_RULER_SOFT_COLOR="#e5e5e5"
    IDE_RULER_HARD_COLOR="#f87171"
else
    NEW="dark"
    GTK_DARK=1
    GSETTINGS_SCHEME="prefer-dark"
    GSETTINGS_THEME="Adwaita-dark"
    IDE_RULER_SOFT_COLOR="#171717"
    IDE_RULER_HARD_COLOR="#7f1d1d"
fi

# Primary: gsettings (works in both GNOME and i3 sessions; gracefully no-op if schema unavailable)
gsettings set org.gnome.desktop.interface color-scheme "$GSETTINGS_SCHEME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "$GSETTINGS_THEME" 2>/dev/null || true

# Fallback: GTK3 settings.ini (for apps that bypass dconf; GNOME does not read/write this file)
sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$GTK_DARK/" \
    ~/.config/gtk-3.0/settings.ini

# Set alacritty them
ln -sf ~/.config/alacritty/theme-$NEW.toml ~/.current-theme.toml

# dunst — swap config and restart (i3-only; no GNOME impact)
cp ~/.config/dunst/dunstrc.$NEW ~/.config/dunst/dunstrc
pkill dunst
dunst &
disown

for f in ~/.config/Cursor/User/settings.json ~/.config/Code/User/settings.json; do
  [ -f "$f" ] || continue
  sed 's|//.*||' "$f" | jq --arg soft "$IDE_RULER_SOFT_COLOR" --arg hard "$IDE_RULER_HARD_COLOR" \
    '."editor.rulers" = [{"column": 80,"color": $soft},{"column": 120,"color": $hard}]' \
    > tmp.json && mv tmp.json "$f"
done

# Persist i3 state
echo "$NEW" > "$STATE_FILE"

# Notify (brief delay for dunst to start)
sleep 0.3
notify-send "Theme" "Switched to $NEW mode" -t 2000 -r 9993
