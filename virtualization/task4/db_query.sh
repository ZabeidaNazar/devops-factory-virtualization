#!/bin/bash

if [ -f /vagrant/.env ]; then
    source /vagrant/.env
fi

mysql -h "192.168.60.20" -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" \
-e "SELECT * FROM test_db.users;" | sudo tee /var/log/db_query.log
