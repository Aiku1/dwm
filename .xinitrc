! sxhkd &
! setxkbmap -option caps:escape
! setxkbmap us intl
! dunst &
! dwm

! pulseaudio --kill
! pulseaudio --start
! pulseaudio --start

while true
do
    ~/.config/dwm_status.sh
    sleep 1s
done &

! feh --bg-center ~/Pictures/black.jpg
