# Android-FCP-Zeroclick
 The code first creates a ngrok tunnel that listens on port 8080. The ngrok tunnel URL is then retrieved and stored in the variable tunnel_url.

Next, a PDF payload file is created. This file will contain a command that will be executed when the PDF file is opened. The command is written to a text file, and the text file is then converted to a PDF file using the pdftk command.

The PDF file is then opened in the background using the xdg-open command. The & character is added to the command so that the PDF file is opened in the background. This prevents the script from waiting for the PDF file to close before continuing.

Finally, the ngrok tunnel URL is printed to the terminal. The scrcpy command is then used to open the PDF file in a remote device and display it on your screen.

Requirements

    ngrok
    pdftk
    scrcpy
