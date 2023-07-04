#!/bin/bash  
# Get the device IP address
device_ip=$(adb shell ip addr show eth0 | grep "inet " | awk '{print $2}')
# Start ngrok
ngrok tcp 5555 -host-tunnels localhost:5555
# Start scrcpy
scrcpy -s $device_ip:5555 
