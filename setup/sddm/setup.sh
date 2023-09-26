#!/bin/zsh

sddm_theme='/usr/share/sddm/themes'
sudo cp -r $1 $sddm_theme

echo 'Modify /etc/sddm.conf to set up theme under the [Theme] section'
