#!/bin/bash

function run {
  if ! pgrep $(basename $1) ;
  then
    $@&
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.config/qtile/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
# wlr-randr --output eDP-1 --scale 2

#if [ $keybLayout = "be" ]; then
#  cp $HOME/.config/qtile/config-azerty.py $HOME/.config/qtile/config.py
#fi

#starting utility applications at boot time
# run fcitx5 & 
# run sxhkd &
run blueman-applet &
run volumeicon &

# numlockx on &
dunst &
# picom --config $HOME/.config/qtile/scripts/picom.conf &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# xss-lock $HOME/.config/qtile/scripts/lock.sh &

# nm-applet does not appear in bar if loaded too early
run nm-applet --indicator &
