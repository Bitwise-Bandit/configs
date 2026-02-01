#!/usr/bin/env bash

# === Configuration ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/sway_wallpaper_index"
MODE="fill" # Can be: fill, fit, stretch, center, tile, solid_color

# === Get list of wallpapers ===
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)

# === Exit if no wallpapers found ===
if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# === Read last index from file or start at 0 ===
if [ -f "$STATE_FILE" ]; then
    INDEX=$(cat "$STATE_FILE")
else
    INDEX=0
fi

# === Wrap around if index is out of bounds ===
INDEX=$((INDEX % ${#WALLPAPERS[@]}))

# === Set the wallpaper ===
pkill swaybg
swaybg -i "${WALLPAPERS[$INDEX]}" -m "$MODE" & disown

# === Save next index ===
echo $(( (INDEX + 1) % ${#WALLPAPERS[@]} )) > "$STATE_FILE"

