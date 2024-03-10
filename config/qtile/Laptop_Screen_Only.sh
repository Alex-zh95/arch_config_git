#!/bin/sh
# xrandr --output eDP-1 --primary --mode 2880x1800 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output DP-2 --off --output HDMI-3 --off --output DP-3 --off --output DP-4 --off --output HDMI-4 --off --output DP-3-1 --off --output DP-3-2 --off --output DP-3-3 --off --output DP-3-4 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output DP-1-4 --off

external=$(xrandr -q | grep -E "[^dis]connected" | grep -v "eDP" | awk '{ printf "%s%s", sep, $1; sep=", " } END{print ""}')

/bin/python3 ~/.config/qtile/screens.py -o "$external" -r "off"
xrandr --output eDP-1 --primary --mode 2880x1800 --pos 0x0 --rotate normal
