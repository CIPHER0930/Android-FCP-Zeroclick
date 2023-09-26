
To run the zeroclick.sh script, you will need to have the following dependencies installed:

A Linux operating system
The following software installed:
Android SDK
scrcpy
pdftk
openssl
ngrok


To Run these script On  Windows OS, 

Windows Subsystem for Linux (WSL): WSL allows you to run a Linux environment natively on Windows. To install WSL, open Settings > Update & Security > For Developers and check the box next to "Windows Subsystem for Linux". Then, install a Linux distribution from the Microsoft Store, such as Ubuntu.
Cygwin: Cygwin is a Unix-like environment for Windows that provides a Unix shell and a large collection of Unix utilities. To install Cygwin, download the installer from the Cygwin website and run it.
MinGW: MinGW is a compiler suite for developing native Windows applications. It also includes a Unix shell and some basic Unix utilities. To install MinGW, download the installer from the MinGW website and run it.
Once you have installed one of the above, you can run the Bash script by opening a terminal (Command Prompt or PowerShell) and navigating to the directory where the script is located. Then, type bash script.sh and press Enter.

For example, if you are using WSL and the script is located in the /home/user/scripts directory, you would type the following command:

bash /home/user/scripts/zeroclick.sh
If you are using Cygwin or MinGW, the command would be the same, except that you would use the full path to the Bash shell executable. For example, if the Bash shell executable is located at C:\cygwin\bin\bash, you would type the following command:

C:\cygwin\bin\bash zeroclick.sh
You may also need to install additional packages on your Linux environment or Unix emulator in order to run the script. For example, the script uses the scrcpy command, so you will need to install the scrcpy package. To do this on Ubuntu, you would run the following command:

sudo apt install scrcpy
To do this on Cygwin, you would run the following command:

cygpkg install scrcpy
Once you have installed all of the necessary packages, you should be able to run the script without any errors.







Once you have installed the dependencies, you can run the script as follows:

zeroclick.sh, you can use the following command:

bash zeroclick.sh
This will start the script in the current directory.

If the script is not in the current directory, you can specify the full path to the script when you run it. For example, if the script is in the /home/user/Android-FCP-Zeroclick directory, you can run it using the following command:

bash /home/user/Android-FCP-Zeroclick/zeroclick.sh
You can also make the script executable and then run it without having to type the bash command. To do this, run the following command:

chmod +x zeroclick.sh
Once you have made the script executable, you can run it using the following command:

./zeroclick.sh
Note: You may need to run the script as root if it needs to access system resources. To do this, run the following command:

sudo bash zeroclick.sh
Warning: This script is a persistent zeroclick script, which means that it will continue to run even after you close the window or terminal in which you started it. To stop the script, you will need to kill the process using a command such as pkill scrcpy.
