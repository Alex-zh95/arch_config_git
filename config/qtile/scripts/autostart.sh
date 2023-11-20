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
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
#autorandr horizontal

#change your keyboard if you need it
#setxkbmap -layout be

keybLayout=$(setxkbmap -v | awk -F "+" '/symbols/ {print $2}')

#if [ $keybLayout = "be" ]; then
#  cp $HOME/.config/qtile/config-azerty.py $HOME/.config/qtile/config.py
#fi

#starting utility applications at boot time
run fcitx5 & 
run sxhkd &
run blueman-applet &
run volumeicon &
run nm-applet --indicator &

numlockx on &
dunst &
picom --config $HOME/.config/qtile/scripts/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xss-lock $HOME/.config/qtile/scripts/lock.sh &
