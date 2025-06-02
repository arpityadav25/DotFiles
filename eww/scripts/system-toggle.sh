#!/bin/bash

# Unified system toggle script with notifications
# Usage: system-toggle.sh {mic|mute|battery|wifi|bluetooth|reboot|shutdown}

case "$1" in
    mic)
        # Toggle microphone mute state using pactl
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        sleep 0.1
        mic_state=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
        if [ "$mic_state" = "yes" ]; then
            notify-send "Mic" "Microphone muted"
        else
            notify-send "Mic" "Microphone unmuted"
        fi
        ;;
    mute)
        # Toggle system audio mute state using pactl
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        sleep 0.1
        vol_state=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
        if [ "$vol_state" = "yes" ]; then
            notify-send "Volume" "System audio muted"
        else
            notify-send "Volume" "System audio unmuted"
        fi
        ;;
    wifi)
        # Toggle WiFi on/off using nmcli and send notification.
        if nmcli radio wifi | grep -q 'enabled'; then
            nmcli radio wifi off
            notify-send "WiFi" "WiFi disabled"
        else
            nmcli radio wifi on
            notify-send "WiFi" "WiFi enabled"
        fi
        eww update wifi-enabled=$(nmcli radio wifi | grep -q enabled && echo true || echo false)
        ;;
    bluetooth)
        # Toggle Bluetooth using bluetoothctl and send notification.
        if bluetoothctl show | grep -q "Powered: yes"; then
        bluetoothctl power off
        rfkill block bluetooth  # Ensures Bluetooth is disabled
        notify-send "Bluetooth" "Bluetooth disabled"
    else
        rfkill unblock bluetooth  # Ensures Bluetooth can be enabled
        bluetoothctl power on
        notify-send "Bluetooth" "Bluetooth enabled"
        fi
        eww update bluetooth-enabled=$(bluetoothctl show | grep -q "Powered: yes" && echo true || echo false)
        ;;
    reboot)
        # Reboot the system.
        reboot now
        ;;
    shutdown)
        # Shutdown the system.
        shutdown now
        ;;
    *)
        echo "Usage: $0 {mic|mute|battery|wifi|bluetooth|reboot|shutdown}"
        exit 1
        ;;
esac
