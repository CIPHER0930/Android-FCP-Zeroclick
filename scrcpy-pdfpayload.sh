#!/bin/bash

# Create a ngrok tunnel
ngrok tcp 8080

# Get the ngrok tunnel URL
tunnel_url=$(ngrok status | grep "Forwarding" | awk '{print $6}')

# Create a PDF payload that will execute a command when opened
pdf_payload="/path/to/payload.pdf"

# Create a text file that contains the command you want to execute
command_file="/path/to/command.txt"

# Write the command to the text file
echo "your command here" > $command_file

# Convert the text file to a PDF file
pdftk $command_file output $pdf_payload

# Open the PDF file automatically in the background
xdg-open $pdf_payload &

# Print the ngrok tunnel URL
echo "Your ngrok tunnel is $tunnel_url"

# Use scrcpy to open the PDF file in a remote device and display it on your screen
scrcpy --pdf="$payload.pdf"







