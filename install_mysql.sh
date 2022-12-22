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

sudo apt-get -y install sysbench

# In mysql add new user for the tests
# mysql> create user sbtest_user identified by 'password';
# mysql> grant all on sbtest.* to `sbtest_user`@`%`;
# mysql> show grants for sbtest_user;

# sysbench --db-driver=mysql --mysql-user=sbtest_user --mysql_password=password --mysql-db=sakila --mysql-host=localhost --mysql-port=3306 --tables=16 --table-size=10000 /usr/share/sysbench/oltp_read_write.lua prepare
