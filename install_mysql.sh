#!/bin/bash

echo "setup starting" >> /var/log/user-data.log

sudo apt update
sudo apt install -y mysql-server

# download sakila db
cd ~
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

# using sudo mysql
# SOURCE /home/ubuntu/sakila-db/sakila-schema.sql;
# SOURCE /home/ubuntu/sakila-db/sakila-data.sql;

# let external pcs connect to mysql
# sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# add bind-address=0.0.0.0 under [mysqld]
# sudo systemctl restart mysql
# ALLOW all connections on port 3306
# sudo ufw allow 3306