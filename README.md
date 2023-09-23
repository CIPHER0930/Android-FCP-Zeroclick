
To run the zeroclick.sh script, you will need to have the following dependencies installed:

ngrok
pdftk
openssl
Once you have installed the dependencies, you can run the script as follows:

./zeroclick.sh <android_device_ip> <pdf_file_1> <pdf_file_2>
Where:

<android_device_ip> is the IP address of the Android device that you want to mirror.
<pdf_file_1> is the first part of the fragmented PDF payload.
<pdf_file_2> is the second part of the fragmented PDF payload.
The script will start a scrcpy session with the Android device and encrypt the PDF payload with AES-256. It will then deliver the encrypted PDF payload to the target using the ngrok tunnel.

Example:

./zeroclick.sh 192.168.1.100 payload.pdf.part1 payload.pdf.part2
This will start a scrcpy session with the Android device at 192.168.1.100 and encrypt the PDF payload consisting of the files payload.pdf.part1 and payload.pdf.part2. The encrypted PDF payload will then be delivered to the target using the ngrok tunnel.
