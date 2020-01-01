#!/bin/bash
# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
get_bytes () {
    # Find active network interface
    interface=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
    line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
    eval $line
    now=$(date +%s%N)
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.

get_velocity() {
    value=$1
    old_value=$2
    now=$3

    timediff=$(($now - $old_time))
    velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
    if test "$velKB" -gt 1024
    then
        echo $(echo "scale=2; $velKB/1024" | bc)MB/s
    else
        echo ${velKB}KB/s
    fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

print_music() {
	#song="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata 2> /dev/null | sed -n '/title/{n;p}' | cut -d '"' -f 2)"
	#artist="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata 2> /dev/null | sed -n '/artist/,$p' | tail -n+3 | head -1 | cut -d '"' -f 2)"

	#if [ -z "$artist" ] || [ -z "$song" ]
	#then
	#	false
	#else
	#	echo -e "${artist} - ${song} |"
	#fi
	echo -e "$(python ~/.config/python_music.py)"
}

print_volume() {
    volume="$(amixer -D pulse sget Master | grep "Right:" | awk -F'[][]' '{ print $2 }')"
    if (( "${volume::-1}" == 0 )); then
	emoji="🔇"
    elif (( "${volume::-1}" >=  1 && "${volume::-1}" < 33 )); then
        emoji="🔈"
    elif (( "${volume::-1}" >= 33 && "${volume::-1}" < 66 )); then
	emoji="🔉"
    else
	emoji="🔊"
   fi

    echo -e "${emoji} ${volume}"
    #echo -e "${volume}"
}

print_wifi() {
	ip=$(ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+')

	if=wlan0
		while IFS=$': \t' read -r label value
		do
			case $label in SSID) SSID=$value
				;;
			signal) SIGNAL=$value
				;;
		esac
	done < <(iw "$if" link)

	echo -e "$SSID $SIGNAL $ip"
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
	echo -e "$memfree MB"
}

print_temp(){
	test -f /sys/class/thermal/thermal_zone0/temp || return 0
	echo $(head -c 2 /sys/class/thermal/thermal_zone0/temp)°C
}

print_bat(){
	hash acpi || return 0
	onl="$(grep "on-line" <(acpi -V))"
    charging="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{$1= ""; print $0}' - )"
    # echo $charging
    case $charging in
        " fully-charged")
            emoji="🗲"
                ;;
        " discharging")
            emoji="🔋"
            ;;
        " charging")
            emoji="🗲🔋"
            ;;
    esac

	charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)"
	if test -z "$onl"
	then
		# suspend when we close the lid
		systemctl --user stop inhibit-lid-sleep-on-battery.service
		echo -e "${emoji} ${charge}"
	else
		# On mains! no need to suspend
		systemctl --user start inhibit-lid-sleep-on-battery.service
		echo -e "${emoji} ${charge}"
	fi
}

print_date(){
    date +"%a %Y/%m/%d, %H:%M"
}

print_brightness(){
    p=$(xbacklight)
    echo ${p%%.*}
}

get_bytes
vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)
vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)

ping -q -w1 -c1 google.com &>/dev/null
if [ $? -eq 0 ]; then
	xsetroot -name "$(print_music) RAM: $(print_mem) | ↓$vel_recv ↑$vel_trans | $(print_temp) | $(print_bat)% | $(print_volume) | $(print_date)"
else
	xsetroot -name "$(print_music) RAM: $(print_mem) | $(print_temp) | $(print_bat)% | $(print_volume) | $(print_date)"
fi

old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now
