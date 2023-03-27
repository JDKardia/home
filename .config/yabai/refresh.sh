#!/usr/bin/env bash

# number_of_windows=$(yabai -m query --windows --space | /opt/homebrew/bin/jq 'length')
# number_of_stacked=$(yabai -m query --windows --space | /opt/homebrew/bin/jq -c 'map(select(."stack-index" != 0)) | length')
# currspace=$(yabai -m query --spaces --space | /opt/homebrew/bin/jq '.index')

# tpadding=
# padding=03
#
# yabai -m config --space "$currspace" top_padding $tpadding
# yabai -m config --space "$currspace" bottom_padding $padding
# yabai -m config --space "$currspace" left_padding $padding
# yabai -m config --space "$currspace" right_padding $padding
# yabai -m config --space "$currspace" window_gap $padding
