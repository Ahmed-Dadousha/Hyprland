#!/bin/bash

# Path to your config file (change this!)
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

# The rule pattern (without comment)
RULE_LINE='windowrule = tile, class:^(burp-.*)$'

# Escape special characters for grep/sed
ESCAPED_RULE=$(printf '%s\n' "$RULE_LINE" | sed 's/[]\/$*.^[]/\\&/g')

# Check if the line exists commented
if grep -q "^#${ESCAPED_RULE}$" "$CONFIG_FILE"; then
    # Uncomment the line
    sed -i "s/^#\(${ESCAPED_RULE}\)$/\1/" "$CONFIG_FILE"
    echo "Uncommented the line."
# Check if it exists uncommented
elif grep -q "^${ESCAPED_RULE}$" "$CONFIG_FILE"; then
    # Comment the line
    sed -i "s/^${ESCAPED_RULE}$/#\0/" "$CONFIG_FILE"
    echo "Commented the line."
else
    echo "Line not found in file."
fi

#while true; do
#
#    sleep 3
#done
