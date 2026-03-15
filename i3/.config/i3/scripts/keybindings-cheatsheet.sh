#!/usr/bin/env bash
# Display all i3 keybindings in a rofi menu as a cheat sheet

config_dir="$HOME/.config/i3"

# Keycode to name mapping
declare -A keycodes=(
    [67]="F1" [68]="F2" [69]="F3" [70]="F4" [71]="F5" [72]="F6"
    [73]="F7" [74]="F8" [75]="F9" [76]="F10" [95]="F11" [96]="F12"
    [135]="Menu"
)

# AZERTY keysym to display name
declare -A keysyms=(
    [ampersand]="1" [eacute]="2" [quotedbl]="3" [apostrophe]="4"
    [parenleft]="5" [minus]="6" [egrave]="7" [underscore]="8"
    [ccedilla]="9" [agrave]="0"
    [Return]="Enter" [Escape]="Esc" [Print]="Print Screen" [Pause]="Pause"
    [space]="Space"
    [XF86AudioRaiseVolume]="Vol +" [XF86AudioLowerVolume]="Vol -"
    [XF86AudioMute]="Mute" [XF86AudioMicMute]="Mic Mute"
    [XF86MonBrightnessUp]="Bright +" [XF86MonBrightnessDown]="Bright -"
)

humanize_key() {
    local raw="$1"
    local result=""
    local parts
    IFS='+' read -ra parts <<< "$raw"

    for i in "${!parts[@]}"; do
        local p="${parts[$i]}"
        case "$p" in
            '$mod'|'Mod4') p="Super" ;;
            'Mod1')        p="Alt" ;;
            'Shift')       p="Shift" ;;
            'Left')        p="←" ;;
            'Right')       p="→" ;;
            'Up')          p="↑" ;;
            'Down')        p="↓" ;;
            *)
                if [[ -n "${keysyms[$p]}" ]]; then
                    p="${keysyms[$p]}"
                elif [[ ${#p} -eq 1 ]]; then
                    p="${p^^}"
                fi
                ;;
        esac
        if [[ $i -gt 0 ]]; then
            result="$result + $p"
        else
            result="$p"
        fi
    done
    echo "$result"
}

entries=()

while IFS= read -r file; do
    comment=""
    is_mode_block=false
    while IFS= read -r line; do
        # Track mode blocks (skip inner bindings)
        if [[ "$line" =~ ^mode\ \" ]]; then
            is_mode_block=true
            continue
        fi
        if [[ "$line" == "}" ]]; then
            is_mode_block=false
            comment=""
            continue
        fi
        $is_mode_block && continue

        # Collect comments
        if [[ "$line" =~ ^#\ (.+) ]]; then
            comment="${BASH_REMATCH[1]}"
            continue
        fi

        # Skip non-binding lines
        if [[ ! "$line" =~ ^bind(sym|code)\ (.+) ]]; then
            comment=""
            continue
        fi

        local_line="${BASH_REMATCH[2]}"

        # Strip --release flag
        local_line="${local_line#--release }"

        # Skip hardware/media keys (obvious bindings)
        if [[ "$local_line" =~ ^XF86 ]]; then
            comment=""
            continue
        fi

        # Extract key combo (first token)
        raw_key="${local_line%% *}"

        # For bindcode, resolve keycode in the key combo
        if [[ "$line" =~ ^bindcode ]]; then
            IFS='+' read -ra kparts <<< "$raw_key"
            resolved=""
            for i in "${!kparts[@]}"; do
                kp="${kparts[$i]}"
                if [[ -n "${keycodes[$kp]}" ]]; then
                    kp="${keycodes[$kp]}"
                fi
                if [[ $i -gt 0 ]]; then
                    resolved="$resolved+$kp"
                else
                    resolved="$kp"
                fi
            done
            raw_key="$resolved"
        fi

        human_key=$(humanize_key "$raw_key")
        desc="${comment:-${local_line#* }}"

        # Store as plaintext for sorting (tab-separated key and description)
        entries+=("${human_key}	${desc}")
        comment=""
    done < "$file"
done < <(find "$config_dir" -maxdepth 1 -name '*.conf' ! -name 'i3blocks.conf' -type f | sort)

# Sort entries, apply pango markup, and display in rofi
IFS=$'\n' sorted=($(printf '%s\n' "${entries[@]}" | sort))
for entry in "${sorted[@]}"; do
    key="${entry%%	*}"
    desc="${entry#*	}"
    echo "<span bgcolor='#3b3b3b' fgcolor='#e0e0e0' font_weight='bold'> ${key} </span>  ${desc}"
done | rofi -dmenu -i -p "Keybindings" -no-custom -markup-rows \
            -theme-str 'window {width: 50%;} listview {lines: 15;}'
