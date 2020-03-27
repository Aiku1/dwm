#!/usr/bin/env sh

chosen=$(grep -v "#" ~/.config/sym | rofi -dmenu -theme monokai)

[ "$chosen" != "" ] || exit


c=$(echo "$chosen" | sed "s/ .*//")
echo "$c" | tr -d '\n' | xclip -selection clipboard
c=$(echo "$chosen" | sed "s/ .*//" | awk '{print $1}')
echo "$c" | tr -d '\n' | xclip
