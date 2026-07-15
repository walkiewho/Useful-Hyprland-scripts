#!/bin/bash

hyprctl --batch "keyword cursor:no_warps true; dispatch focuswindow address:$(/home/ender/.local/scripts/get_windows_by_pos | jq -r '.address'); keyword cursor:no_warps false"
