#!/bin/sh
# Определение текущей оболочки (интерпретатора)

if [ -n "$BASH_VERSION" ]; then
    echo "bash"
elif [ -n "$ZSH_VERSION" ]; then
    echo "zsh"
elif [ -n "$FISH_VERSION" ]; then
    echo "fish"
else
    shell_name=$(ps -p $$ -o comm= 2>/dev/null || ps -p $$ -o args= 2>/dev/null | awk '{print $1}')
    shell_name=$(basename "$shell_name")
    echo "$shell_name"
fi
