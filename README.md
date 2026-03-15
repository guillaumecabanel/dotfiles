# Dotfiles

Desktop configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | What |
|---------|------|
| `i3` | Window manager config, keybindings, scripts, i3blocks |
| `dunst` | Notification daemon (dark/light themes) |
| `rofi` | App launcher |
| `alacritty` | Terminal emulator |
| `i3status` | Status bar fallback |
| `autorandr` | Monitor profiles |
| `gtk` | GTK-3 settings |
| `shell` | Zsh shell config, aliases, starship prompt |
| `zsh` | Zsh startup files |
| `git` | Git config, tig |
| `x11` | X resources, wallpaper |

## Prerequisites

### APT

```bash
sudo apt install \
  i3 i3blocks i3lock \
  rofi dunst picom feh flameshot \
  alacritty \
  zsh \
  stow git tig jq curl \
  autorandr dex xss-lock \
  brightnessctl upower \
  pulseaudio-utils vlc \
  network-manager bluez wireguard-tools \
  libnotify-bin xclip \
  x11-utils x11-xkb-utils \
  papirus-icon-theme adwaita-icon-theme \
  docker.io
```

### Rust & Cargo

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install starship zoxide eza
```

### Other

```bash
# mise (language/tool version manager)
curl https://mise.jdx.dev/install.sh | sh

# lazygit
go install github.com/jesseduffield/lazygit@latest

# lazydocker
go install github.com/jesseduffield/lazydocker@latest

# greenclip (clipboard manager)
# Download binary from https://github.com/erebe/greenclip/releases

# bluetui (bluetooth TUI)
cargo install bluetui

# wlctl (wifi CLI)
# Custom binary — check source

# Fonts: JetBrains Mono Nerd Font
# Download from https://www.nerdfonts.com/font-downloads
```

### Optional

- **VS Code**: `sudo apt install code` (or from https://code.visualstudio.com)
- **Cursor**: https://cursor.sh

## Setup

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Machine-specific overrides

- **Git signing key**: Create `~/.gitconfig.local` for machine-specific git settings (not committed).
- **Autorandr**: Run `autorandr --save <profile>` on new hardware to create monitor profiles.
- **`.theme`**: Runtime state file (gitignored), created by `dark-mode-toggle.sh`.
