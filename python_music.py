#!/usr/bin/env python
# coding: utf8

import dbus
import re
import os
session_bus = dbus.SessionBus()

def printsong(strartist, strtitle):
    strtitle = (strtitle[:25] + "...") if len(strtitle) > 25 else strtitle
    strartist = (strartist[:15] + "...") if len(strartist) > 15 else strartist
    if (re.search("\([^()]*\)", strtitle) is not None):
       print (strartist + " - " + re.sub("\([^()]*\)", "", strtitle) + "|" )
    else:
       print (strartist + " - " + re.sub("\([^()]*\)", "", strtitle) + " |" )
       quit()

try:
    spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify","/org/mpris/MediaPlayer2")
    spotify_properties = dbus.Interface(spotify_bus,"org.freedesktop.DBus.Properties")
    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    strtitle  = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:title']])
    strartist = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:artist']])

    printsong(strartist, strtitle)

except:
    try:
        path = os.popen("cmus-remote -Q 2> /dev/null").read().split('\n')[1]
        strtitle = path.split("/")[6].split(" ")
        strtitle = " ".join((s for s in strtitle if (not s[0].isdigit())))[:-4]
        strartist = path.split("/")[4]

        printsong(strartist, strtitle)

    except:
        print ""

