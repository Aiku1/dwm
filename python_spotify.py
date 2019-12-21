#!/usr/bin/env python
# coding: utf8

import dbus
import re
session_bus = dbus.SessionBus()

try:
    spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify","/org/mpris/MediaPlayer2")
    spotify_properties = dbus.Interface(spotify_bus,"org.freedesktop.DBus.Properties")
    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player", "Metadata")
    strtitle  = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:title']])
    strartist = ''.join([str(e.encode('utf-8')) for e in metadata['xesam:artist']])

    if (re.search("\([^()]*\)", strtitle) is not None):
       print (strartist + " - " + re.sub("\([^()]*\)", "", strtitle) + "|" )
    else:
       print (strartist + " - " + re.sub("\([^()]*\)", "", strtitle) + " |" )
except:
    print ""
