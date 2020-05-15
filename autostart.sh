#!/bin/sh

setxkbmap -option caps:swapescape
setxkbmap us intl
feh --bg-scale ~/Pictures/black.jpg
# feh --bg-scale ~/Pictures/Wallpapers/Landscapes/purple_landscape.jpg
xsetroot -cursor_name left_ptr
xrandr --output LVDS1 --primary --mode 1366x768 --pos 256x1080 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal || xrandr --output LVDS1 --off --output VGA1 --mode 1920x1080 --pos 0x0

[ "$(pgrep -x dunst | wc -w)" = 0 ] && (dunst &)
[ "$(pgrep -x sxhkd | wc -w)" = 0 ] && (sxhkd &)
[ "$(pgrep -x xautolock | wc -w)" = 0 ] && (xautolock -time 10 -locker slock &)
[ "$(pgrep -x caffeine | wc -w)" = 0 ] && (caffeine &)
[ "$(pgrep -x dwmblocks | wc -w)" = 0 ] && (dwmblocks &)
[ "$(pgrep -x redshift | wc -w)" = 0 ] && (redshift -l 40.775:14.746 &)
[ "$(ps -aux | grep clipmenud | wc -l)" = 1 ] && (clipmenud &)
# [ "$(pidof compton | wc -w)" = 0 ] && (compton -time 10 -locker slock &)

