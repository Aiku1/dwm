#!/usr/bin/env python
# coding: utf8

import dbus
import re
import os
session_bus = dbus.SessionBus()

def printsong(strartist, strsep, strtitle):
    strtitle = re.sub("\([^()]*\)", "", strtitle)
    strtitle = (strtitle[:25] + "..") if len(strtitle) > 25 else strtitle
    #strartist = (strartist[:20] + "...") if len(strartist) > 20 else strartist
    #if (re.search("\([^()]*\)", strtitle) is not None):
    #    strend = " |"
    #else:
    #    strend = " |"
    print (strartist + strsep + strtitle + " |")
    quit()

try:
    spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify","/org/mpris/MediaPlayer2")
    spotify_properties = dbus.Interface(spotify_bus,"org.freedesktop.DBus.Properties")
    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    strtitle  = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:title']])
    strartist = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:artist']])

    printsong(strartist, " -" , strtitle)

except:
    try:
        strartist = os.popen("cmus-remote -Q | grep --text '^tag artist' | sed '/^tag artistsort/d' | awk '{gsub(\"tag artist \", \"\");print}'").read()[0:-1]
        strtitle = os.popen("cmus-remote -Q | grep --text '^tag title' | sed -e 's/tag title //' | awk '{gsub(\"tag title \", \"\");print}'").read()[0:-1]

        printsong(strartist, " - ", strtitle)

    except:
        print ""

