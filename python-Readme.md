README
This script generates a PDF payload that can be used to control an Android device remotely. The script also starts the ngrok tunnel and opens the PDF file automatically in the background.

To run the script, type the following command:

python script.py

The script will print the ngrok tunnel URL, which you can use to connect to your Android device from a remote location.

Once you are connected to your Android device, you can use the scrcpy tool to control it remotely.

To install the required modules, type the following command:

pip install -r requirements.txt    
Here is a requirements.txt file that you can use to install the required modules:

subprocess
tempfile
webbrowser
pdftk
openssl
ngrok
