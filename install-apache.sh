#!/bin/bash

apt update -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<html><body><h1>WEB Tier EC2 Instance Deployed</h1></body></html>" > /var/www/html/index.html