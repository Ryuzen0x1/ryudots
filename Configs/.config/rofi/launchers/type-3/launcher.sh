#!/usr/bin/env bash

## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10
## Run
#
#rofi \
#    -show drun \
#    -theme ${dir}/${theme}.rasi

dir="$HOME/.config/rofi/launchers/type-3"
theme='style-5'


cliphist list | rofi \
    -dmenu \
    -i -theme ${dir}/${theme}.rasi \
    | cliphist decode | wl-copy --type text/plain
