#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install apache2 mysql-client prometheus-node-exporter -y

sudo mkdir -p /var/www/html

echo "<h1>Welcome to the Web Server!</h1>" | sudo tee /var/www/html/index.html > /dev/null

sudo systemctl enable apache2
sudo systemctl restart apache2
sudo systemctl is-active apache2
