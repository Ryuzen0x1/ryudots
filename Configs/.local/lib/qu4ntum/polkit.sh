#!/usr/bin/env bash
# This is for polkits, it will start from top and will stop if the top is executed
# Polkit possible paths files to check
# Use different directory on NixOS
if [ -d /run/current-system/sw/libexec ]; then
    libDir=/run/current-system/sw/libexec
else
    libDir=/usr/lib
fi

${libDir}/polkit-gnome/polkit-gnome-authentication-agent-1 &
