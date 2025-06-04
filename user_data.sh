#!/bin/bash
apt-get update -y
apt-get install -y apache2

# Enable Apache at boot and start it
systemctl enable apache2
systemctl start apache2

echo "<h1>Hello from $(hostname) test SSL certifcate and HTTPS connection</h1>" > /var/www/html/index.html