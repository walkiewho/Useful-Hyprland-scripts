#!/bin/bash

CLASS="chrome-chatgpt.com__-Default"
CMD="chromium --user-data-dir=\"$HOME/.config/chromium-profiles/chatgpt\" --app=https://chatgpt.com"
SPECIAL="chatgpt"

CLIENT=$(hyprctl clients -j | jq -c ".[] | select(.class==\"$CLASS\")" | head -n 1)

if [ -z "$CLIENT" ]; then
    hyprctl dispatch exec "[workspace special:$SPECIAL] $CMD" &
    exit 0
else
    hyprctl dispatch togglespecialworkspace "$SPECIAL"
fi
