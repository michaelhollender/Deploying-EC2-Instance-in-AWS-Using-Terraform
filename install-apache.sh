#!/bin/bash

dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1>WEB Tier EC2 Instance Deployed</h1></body></html>" > /var/www/html/index.html