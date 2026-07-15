#!/bin/bash

ADDR_FILE="/tmp/toggle_window.addr"

VISIBLE_X=5
HIDDEN_X=-505
Y=100


if [[ -f "$ADDR_FILE" ]]; then
    ADDR=$(<"$ADDR_FILE")

    if ! hyprctl clients -j | jq -e --arg addr "$ADDR" '.[] | select(.address == $addr)' >/dev/null; then
        rm -f "$ADDR_FILE"
        ADDR=""
    fi
fi


if [[ -z "$ADDR" ]]; then

    BEFORE=$(hyprctl clients -j | jq -r '.[].address')

    hyprctl dispatch exec "[float; size 400 800; move $VISIBLE_X 100; opacity 0.9] mousepad"

    while true; do
        ADDR=$(hyprctl clients -j | jq -r \
            --argjson before "$(printf '%s\n' "$BEFORE" | jq -R . | jq -s .)" '
            .[]
            | select(.address as $a | ($before | index($a) | not))
            | .address
        ' | head -n1)

        [[ -n "$ADDR" ]] && break
        sleep 0.05
    done

    echo "$ADDR" > "$ADDR_FILE"
    exit 0
fi


POS=$(hyprctl clients -j | jq -r --arg addr "$ADDR" \
    '.[] | select(.address == $addr) | .at[0]')
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

WINDOW_WS=$(hyprctl clients -j | jq -r --arg addr "$ADDR" \
    '.[] | select(.address == $addr) | .workspace.id')

if (( POS < 0 )) || [[ "$WINDOW_WS" != "$CURRENT_WS" ]]; then
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

    hyprctl dispatch movetoworkspacesilent "$CURRENT_WS",address:"$ADDR"
    hyprctl dispatch movewindowpixel exact "$VISIBLE_X" "$Y",address:"$ADDR"
    hyprctl --batch "keyword cursor:no_warps true; dispatch focuswindow address:$ADDR; keyword cursor:no_warps false"
else
    hyprctl dispatch movewindowpixel exact "$HIDDEN_X" "$Y",address:"$ADDR"
    /home/ender/.local/scripts/focus_window_under_cursor.sh
    # Force cursor to focus window under cursor but after focusing, cursor moves to center of window
fi