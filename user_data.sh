#!/bin/bash
sudo yum  update -y
sudo yum install -y httpd

# Enable Apache at boot and start it
sudo systemctl enable httpd
sudo systemctl start httpd

# Write HTML content to the default web page
sudo touch /var/www/html/index.html
sudo -i
echo "<h1>Hello from $(hostname) test SSL certifcate and HTTPS connection</h1>" > /var/www/html/index.html
exit
sudo systemctl restart httpd