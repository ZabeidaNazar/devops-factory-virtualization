#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

MYSQL_USER_IP="${MYSQL_USER_IP:-localhost}"
PRIVATE_NETWORK="${PRIVATE_NETWORK:-127.0.0.1}"

sudo apt-get update
sudo apt-get install mysql-server -y

sudo sed -i "s/^bind-address.*/bind-address = $PRIVATE_NETWORK/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl enable mysql
sudo systemctl restart mysql

sudo systemctl is-active mysql

sudo mysql -e "CREATE DATABASE IF NOT EXISTS test_db;"
sudo mysql -e "USE test_db; CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY, name VARCHAR(255));"
sudo mysql -e "USE test_db; INSERT IGNORE INTO users (id, name) VALUES (1, 'Alice'), (2, 'Bob');"

if [[ -n "$MYSQL_USERNAME" && -n "$MYSQL_PASSWORD" ]]; then
    sudo mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USERNAME'@'$MYSQL_USER_IP' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_PASSWORD';"
    sudo mysql -e "GRANT SELECT ON test_db.users TO '$MYSQL_USERNAME'@'$MYSQL_USER_IP';"
    sudo mysql -e "FLUSH PRIVILEGES;"
else
    echo "Змінна MYSQL_USERNAME або MYSQL_PASSWORD не задана."
    echo "Користувача не створено."
fi
