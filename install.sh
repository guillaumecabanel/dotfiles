#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES=(i3 dunst rofi alacritty i3status autorandr gtk shell zsh git x11)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Check/install stow
if ! command -v stow &>/dev/null; then
    echo "Installing stow..."
    sudo apt install -y stow
fi

# Remove old debready symlinks if they exist
debready_links=(
    "$HOME/.config/alacritty"
    "$HOME/.config/shell"
    "$HOME/.config/starship.toml"
)
for link in "${debready_links[@]}"; do
    if [ -L "$link" ]; then
        echo "Removing debready symlink: $link"
        rm "$link"
    fi
done

# Back up conflicting real files
backup_needed=false
for pkg in "${PACKAGES[@]}"; do
    while IFS= read -r -d '' file; do
        rel="${file#"$DOTFILES_DIR/$pkg/"}"
        target="$HOME/$rel"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            backup_needed=true
            backup_path="$BACKUP_DIR/$rel"
            mkdir -p "$(dirname "$backup_path")"
            echo "Backing up: $target -> $backup_path"
            mv "$target" "$backup_path"
        elif [ -L "$target" ]; then
            rm "$target"
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
done

if [ "$backup_needed" = true ]; then
    echo "Backups saved to $BACKUP_DIR"
fi

# Stow each package
cd "$DOTFILES_DIR"
for pkg in "${PACKAGES[@]}"; do
    echo "Stowing $pkg..."
    stow -t "$HOME" "$pkg"
done

# Bootstrap generated config files (not tracked in git)
DUNSTRC="$HOME/.config/dunst/dunstrc"
if [ ! -f "$DUNSTRC" ]; then
    echo "Generating default dunstrc (dark theme)..."
    cp "$DOTFILES_DIR/dunst/.config/dunst/dunstrc.dark" "$DUNSTRC"
fi

GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"
if [ ! -f "$GTK_SETTINGS" ]; then
    echo "Generating default GTK settings (dark theme)..."
    cat > "$GTK_SETTINGS" << 'GTEOF'
[Settings]
gtk-application-prefer-dark-theme=1
GTEOF
fi

echo "Done! All packages stowed."
