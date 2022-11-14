#!/bin/bash

# Terminate already running bar instances
pkill polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini
if command -v "xrandr" > /dev/null; then
  echo "Launching polybar for each screen"
  xrandr --listactivemonitors | grep -oP '(HDMI\-\d+$|DP\-\d+$)' | xargs -P1 -I{} bash -c 'MONITOR={} polybar -r 2>&1 | tee -a /tmp/polybar.log & disown'
else
  polybar -r i3 2>&1 | tee -a /tmp/polybar.log & disown
fi
echo "Polybar launched..."
