#!/bin/bash
# get-active-ws.sh

# Get the active workspace index (0-3)
active_ws=$(xdotool get_desktop)
echo $active_ws
