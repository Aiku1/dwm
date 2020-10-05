#!/bin/bash

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
setxkbmap -option caps:swapescape
setxkbmap us intl
xset m 0 0
xset s off

xsetroot -cursor_name left_ptr
# xrandr --output LVDS1 --primary --mode 1366x768 --pos 256x1080 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal || xrandr --output LVDS1 --off --output VGA1 --mode 1920x1080 --pos 0x0
/home/usr/.local/bin/ramdisk.sh &

[[ -z $(pgrep -xU $UID mpdscribble) ]] && (mpdscribble &)
[[ -z $(pgrep -xU $UID mpd) ]] && (mpd ~/.config/mpd/mpd.conf &)
[ "$(pgrep -x unclutter | wc -w)" = 0 ] && (unclutter &)
[ "$(pgrep -x dunst | wc -w)" = 0 ] && (dunst &)
[ "$(pgrep -x sxhkd | wc -w)" = 0 ] && (sxhkd &)
[ "$(pgrep -x xautolock | wc -w)" = 0 ] && (xautolock -corners ---- -time 10 -locker /home/usr/.local/bin/lock.sh &)
[ "$(pgrep -x picom | wc -w)" = 0 ] && (picom -CGb && hsetroot -solid "#000")
[ "$(pgrep -x caffeine | wc -w)" = 0 ] && (caffeine &)
[ "$(pgrep -x dwmblocks | wc -w)" = 0 ] && (dwmblocks &)
[ "$(pgrep -x redshift | wc -w)" = 0 ] && (redshift -l 40.775:14.746 &)
[ "$(ps -aux | grep clipmenud | wc -l)" = 1 ] && (clipmenud &)

