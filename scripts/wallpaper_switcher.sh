#!/usr/bin/env bash

# Configuration
WALLPAPER_DIR="$HOME/wallpaper1"
STATE_FILE="/tmp/swww_state"
LIST_CACHE="/tmp/swww_list"

# 1. Ultra-Fast Daemon Check
if ! swww query >/dev/null 2>&1; then
  swww-daemon --format xrgb &
  until swww query >/dev/null 2>&1; do sleep 0.01; done
fi

# 2. Optimized Sequential Selection
if [[ ! -f "$LIST_CACHE" ]]; then
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort >"$LIST_CACHE"
fi

idx=$(cat "$STATE_FILE" 2>/dev/null || echo 1)
selectedWallpaper=$(sed -n "${idx}p" "$LIST_CACHE")

if [[ -z "$selectedWallpaper" ]]; then
  idx=1
  selectedWallpaper=$(sed -n "${idx}p" "$LIST_CACHE")
  [[ -z "$selectedWallpaper" ]] && {
    echo "No wallpapers found"
    exit 1
  }
fi

# Update state immediately for next run
echo $((idx + 1)) >"$STATE_FILE"

# 3. Smooth Fade Transition
# --transition-type fade: Uses bezier curves for high-quality fading
# --transition-step: Controls speed (2 is slow/smooth, 255 is instant)
# --transition-duration: Length in seconds (decimal allowed)
swww img "$selectedWallpaper" \
  --transition-type fade \
  --transition-step 2 \
  --transition-duration 0.5 \
  --transition-fps 60
