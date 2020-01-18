#!/usr/bin/env python
# coding: utf8

import dbus
import re
import os
session_bus = dbus.SessionBus()

def printsong(strartist, strsep, strtitle):
    if (re.search("\([^()]*\)", strtitle) is not None):
        strend = "|"
    else:
        strend = " |"
    strtitle = re.sub("\([^()]*\)", "", strtitle)
    strtitle = (strtitle[:20] + "..") if len(strtitle) > 20 else strtitle
    #strartist = (strartist[:20] + "...") if len(strartist) > 20 else strartist
    print (strartist + strsep + strtitle + strend)
    quit()

try:
    #spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify","/org/mpris/MediaPlayer2")
    #spotify_properties = dbus.Interface(spotify_bus,"org.freedesktop.DBus.Properties")
    #metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    #strtitle  = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:title']])
    #strartist = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:artist']])

    spotifyid=os.popen("ps -ef | grep '[/]usr/share/spotify' | awk '{print $2}' | head -1").read()[:-1]
    if spotifyid:
	currentsong=os.popen("wmctrl -l -p | grep '" + spotifyid + "' | sed -n 's/.*'x230'//p'").read()[:-1]
	if currentsong != " Spotify" and currentsong != " Spotify Premium":
	    print (currentsong + " |")

except:
    try:
        strartist = os.popen("cmus-remote -Q | grep --text '^tag artist' | sed '/^tag artistsort/d' | awk '{gsub(\"tag artist \", \"\");print}'").read()[0:-1]
        strtitle = os.popen("cmus-remote -Q | grep --text '^tag title' | sed -e 's/tag title //' | awk '{gsub(\"tag title \", \"\");print}'").read()[0:-1]
        sep = " - "
        if (strartist == "" or strtitle == ""):
           path = os.popen("cmus-remote -Q 2> /dev/null").read().split('\n')[1]
           length = len(path)
           last_slash = path.rindex("/", 0, length)
           last_dot = path.rindex(".", last_slash, length)
           strtitle = path[last_slash + 1 : last_dot]
           if (re.search("^\d+", strtitle) is not None):
              sep = " -"
           strtitle = re.sub(r"^\d+", "", strtitle)
           strtitle = re.sub(r"^\ \-", "", strtitle)
           strtitle = "".join((s for s in strtitle if (not s[0].isdigit())))[:-4]
           strartist = path.split("/")[4]

        printsong(strartist, sep, strtitle)

    except:
        print ("")
