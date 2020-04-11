import os
import urllib.request, urllib.parse
from bs4 import BeautifulSoup
import subprocess
import requests
import unicodedata
import re
import time

def urlready(s):
    s = s.rstrip().lstrip().strip().replace(".","")
    re.sub(r"[^0-9a-zA-Z]", '', s)
    return s

def lyrics():
    if subprocess.call("check_music.sh") == 0:
        subprocess.call("music_py > out 2> err", shell=True)
        song = open("out").read()
        artist = (song[song.find(")")+2:song.find("-")-1])
        songname = (song[song.find("-")+2:-1])
        searchurl = "https://search.azlyrics.com/search.php?q=" + urlready(artist).replace(" ", "+").lower() + "+" + urlready(songname).replace(" ", "+").lower()

        try:
            htmltext = urllib.request.urlopen(searchurl).read().decode("utf-8")
            soup = BeautifulSoup(htmltext,"lxml")
            url = soup.find("table").find("a")["href"]
            htmltext = urllib.request.urlopen(url).read().decode('utf-8')
            soup = BeautifulSoup(htmltext, "lxml")
            lyrics = soup.find_all('div', class_="")[0].text.rstrip().lstrip().strip()
            re.sub(r"<(.*?)>", '', lyrics[0])
        except:
            print("Lyrics not found..😞")
            print(searchurl)
            return

        strout="{}\n{}\n{}\n".format(url, song, lyrics)
    else:
        strout="No music playling."

    #print(strout.center(100))
    strout = strout.split("\n")
    for s in strout:
        print ("{: ^50s}".format(s))





lyrics()
