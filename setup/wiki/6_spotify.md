# Setting up spotifyd and spotify-tui

These instructions are optional for the set-up for spotify on command line if we don't want to use the Spotify web-app (Electron-based). Note this only works for Spotify premium.

## spotifyd

Install spotifyd via pacman. For the setup, create a set-up file under `.config/spotifyd/spotifyd.conf`. In this file, following example has worked for the device.

```[toml]
[global]
# Spotify Credentials: Username is actual user name, not email
username = "your_username_here"
password = "your_passwd_here"

# Audio backend to play your music. To get
# a list of all possible backends, run `spotifyd --help`
backend = "alsa"

# The device name can't have spaces
device = "surround71"
device_name = "Tuxedo-Infinitybook"
device_type = "computer"

dbus_type = "system"
use_mpris = false

# Audio bitrate
bitrate = 320
mixer = "PCM"
audio_format = "S32"

# Create a cache directory but does not use it 
cache_path = "/home/chu/.cache/spotifyd"
no_audio_cache = true

# Set the inital volume of spotify to 100
initial_volume = "100"
volume_controller = "alsa"

# Tweak if too loud/quiet by default
normalisation_pregain = 10

zeroconf_port = 4444
```

To get the username, log into Spotify on the web and retrieve the actual username. We cannot use the email address here. For the password, we might want a more secure way to store (i.e. rely on system password managers rather than as plaintext here).

We can either use systemd to set up the daemon or the easier approach is to run it with spotify-tui.

## spotify-tui

Install spotify-tui from the AUR.

To set up, we need to open the [Spotify dashboard](https://developer.spotify.com/dashboard) and create an app. Write whatever for a name and description. 

For the "Redirect URI", write `http://localhost:8888/callback`. Retrieve the Client ID and Client Secret after app creation.

Launch spotify-tui with `spt`. Enter the Client ID and Client Secret at prompt. Confirm the default port of 8888 or enter a custom port, based on what was provided above. Then follow the instructions and copy final URL into the terminal.

We should now all be set.

Run `spotfiyd` then `spt` to use.
