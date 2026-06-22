#!/bin/bash

echo "<h1>Welcome to the Web Server!</h1>" > /var/www/html/index.html
sudo apt update
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

