#!/bin/bash

sudo apt update
sudo apt install mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql

mysql -e "CREATE DATABASE IF NOT EXISTS test_db;"
mysql -e "USE test_db; CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY, name VARCHAR(255));"

mysql -e "USE test_db; INSERT INTO users (id, name) VALUES (1, 'Alice'), (2, 'Bob');"
