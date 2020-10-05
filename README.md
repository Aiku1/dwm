# My dwm build

Here's my build of dwm.

## Patches and features

- reads xresources colors
- scratchpad accessible with mod+enter
- true fullscreen and prevents focus shifting
- windows can be made sticky
- gaps around windows and bar
- dwmc

## Please install `libxft-bgra`!

This build of dwm does not block color emoji in the status/info bar, so you must install [libxft-rbgra](https://aur.archlinux.org/packages/libxft-bgra/) from the AUR, which fixes a libxft color emoji rendering problem, otherwise dwm will crash upon trying to render one. Hopefully this fix will be in all libxft soon enough.
