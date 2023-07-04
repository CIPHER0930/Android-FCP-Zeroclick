# This script will start TeamViewer on login and create a ngrok tunnel for port 5900

# Start TeamViewer on login
teamviewer --startonlogin

# Create a ngrok tunnel for port 5900
ngrok tcp 5900
