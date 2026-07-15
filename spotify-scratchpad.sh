#!/bin/bash

CLASS="Spotify"
CMD="spotify-launcher"
SPECIAL="spotify"

CLIENT=$(hyprctl clients -j | jq -c ".[] | select(.class==\"$CLASS\")" | head -n 1)

if [ -z "$CLIENT" ]; then
    hyprctl dispatch exec "[workspace special:$SPECIAL] $CMD" &
    exit 0
else
    hyprctl dispatch togglespecialworkspace "$SPECIAL"
fi
