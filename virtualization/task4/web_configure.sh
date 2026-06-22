#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y

echo "<h1>Welcome to the Web Server!</h1>" > /var/www/html/index.html

sudo systemctl enable apache2
sudo systemctl start apache2
