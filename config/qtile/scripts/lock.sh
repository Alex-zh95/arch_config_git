#!/bin/sh
alpha='dd'
background='#c0c5ce'
selection='#2e3440'
comment='#4c566a'

yellow='#ebcb8b'
orange='#d08770'
red='#bf616a'
magenta='#b48ead'
blue='#81a1c1'
cyan='#77c0d0'
green='#a3be8c'

i3lock \
  --insidever-color=$selection$alpha \
  --insidewrong-color=$selection$alpha \
  --inside-color=$selection$alpha \
  --ringver-color=$green$alpha \
  --ringwrong-color=$red$alpha \
  --ringver-color=$green$alpha \
  --ringwrong-color=$red$alpha \
  --ring-color=$blue$alpha \
  --line-uses-ring \
  --keyhl-color=$orange \
  --bshl-color=$orange$alpha \
  --separator-color=$selection$alpha \
  --verif-color=$yellow \
  --wrong-color=$red \
  --layout-color=$blue \
  --date-color=$blue \
  --time-color=$blue \
  --screen 1 \
  --blur 1 \
  --clock \
  --indicator \
  --time-str="%H:%M" \
  --date-str="%A %e %B %Y" \
  --verif-text="" \
  --wrong-text="" \
  --noinput="?" \
  --lock-text="" \
  --lockfailed=" " \
  --radius=120 \
  --ring-width=10 \
  --pass-media-keys \
  --pass-screen-keys \
  --pass-volume-keys \
  --time-font="FiraCode-Retina" \
  --date-font="FiraCode-Retina" \
  --layout-font="FiraCode-Retina" \
  --verif-font="FiraCode-Retina" \
  --wrong-font="FiraCode-Retina" \
  --greeter-font="FiraCode-Retina" \
#
