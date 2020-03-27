print_music() {
    #echo -e "$(python ~/.config/python_music.py)"
    #get cmus data
    if [ $(pgrep -x cmus$) ]; then
        cmusartist="$(cmus-remote -Q 2> /dev/null | grep --text '^tag artist' | sed -e 's/tag artist //')"
        cmustitle="$(cmus-remote -Q 2> /dev/null | grep --text '^tag title' | sed -e 's/tag title //')"
        cmustimeTot="$(cmus-remote -Q 2> /dev/null | grep --text '^duration' | sed -e 's/duration //')"
        cmustime="$(cmus-remote -Q 2> /dev/null | grep --text '^position' | sed -e 's/position //')"
        cmustimeTot="$(date -d @$((cmustimeTot)) +%M:%S)"
        cmustime="$(date -d @$((cmustime)) +%M:%S)"

        case $(cmus-remote -Q 2> /dev/null | grep --text "^status" | sed -e 's/status //') in
            playing)
                emoji="▶️" ;;
            paused)
                emoji="⏸️" ;;
        esac

        cmustitle=$(echo $cmustitle | sed "s/ ([^)]*)//g")
        [ ${#cmustitle} -gt 20 ] && cmustitle="$(echo $cmustitle | cut -b 1-20)…"

        [ "$cmustimeTot" != "00:00" ] && printf " (%s %s/%s) %s - %s |\0" "$emoji" "$cmustime" "$cmustimeTot" "$cmusartist" "$cmustitle"
    fi

    # get mpd data
    if [ $(pgrep -x mpd) ]; then
        mpdsong="$(mpc status 2> /dev/null | head -1 | sed "s/([^)]*)//g")"
        mpdtime="$(mpc status 2> /dev/null | tr '\n' ';' | awk '{ split($0,a,";"); split(a[2], b," "); print b[3] }')"
        [ "$mpdtime" ] && echo " ($mpdtime) $mpdsong |"
    fi

    #get spotify data
    if [ $(pgrep -x spotify | head -1) ]; then
        spotifypid=$(pgrep -x spotify | head -1)
        spotifytitle="$(eval "wmctrl -l -p | awk '/$spotifypid/' | sed -n 's/.*x230 //p'")"
        spotifytitle=$(echo $spotifytitle | sed "s/([^)]*)//g")
        [ "$spotifytitle" != "Spotify Premium" ] && [ "$spotifytitle" != "Spotify" ] && echo " $spotifytitle |"
    fi
}

print_volume() {
    volume="$(amixer -D pulse sget Master | grep "Right:" | awk -F'[][]' '{ print $2 }' | sed 's/\%//')"

    [ "$volume" -eq  "0" ] && emoji="🔇"
    [ "$volume" -ge  "1" ] && [ "$volume" -lt "33" ] && emoji="🔈"
    [ "$volume" -ge "33" ] && [ "$volume" -lt "66" ] && emoji="🔉"
    [ "$volume" -ge "66" ] && emoji="🔊"

   echo "${emoji} ${volume}%"
}

print_mem(){
    echo $(($(awk '/MemAvailable/ {print $2}' /proc/meminfo) / 1024)) MB
}

print_temp(){
    test -f /sys/class/thermal/thermal_zone0/temp || return 0
    echo $(head -c 2 /sys/class/thermal/thermal_zone0/temp)°C
}

print_bat(){
    hash acpi || return 0
    onl="$( acpi -V | grep "on-line" )"
    charging="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{$1= ""; print $0}' - )"

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
    echo "${emoji} ${charge}"
}

print_date(){
    date +"%a %Y/%m/%d, %H:%M"
}

print_brightness(){
    p=$(xbacklight)
    echo ${p%%.*}
}

ping -q -w1 -c1 1.1.1.1 >/dev/null
if [ $? -eq 0 ]; then
    xsetroot -name "$(print_music) $(print_mem) | $(print_temp) | $(print_bat)% | $(print_volume) | $(print_date) "
else
    xsetroot -name " NO CONNECTION | $(print_music) $(print_mem) | $(print_temp) | $(print_bat)% | $(print_volume) | $(print_date) "
fi
