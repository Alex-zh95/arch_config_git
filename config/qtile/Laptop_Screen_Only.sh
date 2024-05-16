#!/bin/sh

# Find all external displays by name (i.e. those that do not contain string "eDP")
external=$(xrandr -q | grep -E "[^dis]connected" | grep -v "eDP" | awk '{ printf "%s%s", sep, $1; sep=", " } END{print ""}')

# Pipe this to screens.py to turn off
/bin/python3 ~/.config/qtile/screens.py -o "$external" -r "off"

# Now turn on the internal display
xrandr --output eDP-1 --primary --mode 2880x1800 --pos 0x0 --rotate normal
echo "eDP-1 (internal display) active"
