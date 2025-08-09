#!/bin/bash

# Path to your config file (change this!)
CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"

# The rule pattern (without comment)
RULE_LINE='windowrule = tile, class:^(burp-.*)$'
# Burp process check
if pgrep -f "java .*burpsuite_pro_v2022.8.jar" > /dev/null; then
    burp_running=true
else
    burp_running=false
fi

# Escape special characters for grep/sed
ESCAPED_RULE=$(printf '%s\n' "$RULE_LINE" | sed 's/[]\/$*.^[]/\\&/g')

if ! $burp_running; then
    # Check if the line exists commented
    if grep -q "^#${ESCAPED_RULE}$" "$CONFIG_FILE"; then
        # Uncomment the line
        sed -i "s/^#\(${ESCAPED_RULE}\)$/\1/" "$CONFIG_FILE"
        echo "Uncommented the line."
    fi
else
    # Check if it exists uncommented
    if grep -q "^${ESCAPED_RULE}$" "$CONFIG_FILE" && [[ -n "$1" ]]; then
        # Comment the line
        sed -i "s/^${ESCAPED_RULE}$/#\0/" "$CONFIG_FILE"
        echo "Commented the line."
    else
        echo "Line not found in file."
    fi
fi


