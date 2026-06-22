#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install apache2 -y

sudo mkdir -p /var/www/html

sudo echo "<h1>Welcome to the Web Server!</h1>" | sudo tee /var/www/html/index.html > /dev/null

sudo systemctl enable apache2
sudo systemctl start apache2
