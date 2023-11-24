#!/bin/bash

function run {
  if ! pgrep $(basename $1) ;
  then
    $@&
  fi
}

killall nm-applet
run nm-applet --indicator &
