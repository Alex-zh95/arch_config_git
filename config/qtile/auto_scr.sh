#!/bin/bash
# Automatically toggle screen projection based on what screens have been connected. Encode in a key in temporary file.
# If the key is 1, then we have that external screens are connected, so switch to laptop only;
# If key is 0, then we are laptop only, so we attempt to connect to all external.
# If the file does not exist, then we have clearly just booted (or for some reason deleted it...)
# and we are laptop only.

TMP_FILE="/tmp/screens_tog.tmp"

# Check if file exists
if [ -f "$TMP_FILE" ]; then
    # Read the key value from file
    KEY=$(cat "$TMP_FILE")
    echo "Read key from temp keyfile."
else
    # If file does not exist, we are laptop-only so assume mode 0
    KEY=0

    # Also make the temp file and echo the key into it.
    echo 0 > "$TMP_FILE"
    echo "Temp keyfile set up successfully."
fi

# If we we are in laptop-only mode, we project to all connected screens.
if [ "$KEY" -eq 0 ]; then
    # Automate the screens.py script by looking for all connected monitors, excluding built-in (designated here by "eDP-x",
    # printing out the list of these as comma-separated values and passing as argument into screen.py's -o flag
    /bin/python3 ~/.config/qtile/screens.py -o "$(xrandr -q | grep -E "[^dis]connected" | grep -v "eDP" | awk '{ printf "%s%s", sep, $1; sep=", " } END{print ""}')" -d True

    # Update the key file with 1
    echo 1 > "$TMP_FILE"
elif [ "$KEY" -eq 1 ]; then
    # We have connected to external, so we now go to laptop-only
    # Find all external displays by name (i.e. those that do not contain string "eDP")
    external=$(xrandr -q | grep -E "[^dis]connected" | grep -v "eDP" | awk '{ printf "%s%s", sep, $1; sep=", " } END{print ""}')

    # Pipe this to screens.py to turn off
    /bin/python3 ~/.config/qtile/screens.py -o "$external" -r "off"

    # Now turn on the internal display
    xrandr --output eDP-1 --primary --mode 2880x1800 --pos 0x0 --rotate normal
    echo "eDP-1 (internal display) active"

    # Update the key file with 0
    echo 0 > "$TMP_FILE"
fi
