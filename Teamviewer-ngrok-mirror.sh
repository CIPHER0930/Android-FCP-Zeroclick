#!/bin/bash

# Get the remote computer name
remote_computer_name="<remote_computer_name>"

# Connect to the remote computer using TeamViewer
teamviewer connect $remote_computer_name

# Create a tunnel to the remote computer using ngrok
ngrok tcp 5900

# Copy the ngrok URL
ngrok_url=$( ngrok tcp 5900 | grep "Forwarding" | awk '{print $7}' )

# Open a web browser and navigate to the ngrok URL
xdg-open $ngrok_url
