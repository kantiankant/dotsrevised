#!/usr/bin/env zsh
# Ensure the screenshots directory exists
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Define filename with a 2026 timestamp
FILE="$DIR/screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Select area with slurp and capture with grim
# This also copies the result to your clipboard
grim -g "$(slurp)" - | tee "$FILE" | wl-copy

# Optional: Notification
notify-send "Screenshot Captured" "Saved to $FILE" -i camera-photo
