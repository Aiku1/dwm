#~/bin/bash
c=$(echo "1 - Home\n2 - Mobile\n3 - Rotate VGA Left\n4 - Rotate VGA Normal" | rofi -dmenu -theme monokai)
c=$(echo $c | cut -c1)

case $c in
	[1,4])
		xrandr --output LVDS1 --primary --mode 1366x768 --pos 256x1080 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
		;;
	"2")
		xrandr --output VGA1 --off --output LVDS1 --auto --pos 0x0
		;;
	"3")
		xrandr --output LVDS1 --primary --mode 1366x768 --pos 1080x1152 --rotate normal --output VGA1 --mode 1920x1080 --pos 0x0 --rotate right
		;;
esac
