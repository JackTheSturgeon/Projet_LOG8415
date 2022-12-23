#!/bin/bash

echo "setup starting" >> /var/log/user-data.log

sudo apt update
sudo apt install -y mysql-server

# download sakila db
cd ~
wget https://downloads.mysql.com/docs/sakila-db.tar.gz
tar -xvf sakila-db.tar.gz

# Set up sakila database inside mysql
"""
SOURCE /home/ubuntu/sakila-db/sakila-schema.sql;
SOURCE /home/ubuntu/sakila-db/sakila-data.sql;
# show full tables; pour voir si sakila est bien setup
"""

# let external computers connect to mysql
# add bind-address=0.0.0.0 under [mysqld]
"""
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
ALLOW all connections on port 3306
sudo ufw allow 3306
"""
sudo apt-get -y install sysbench

# Add user for the tests and grant privileges on sakila db
"""
create user sbtest_user identified by 'password';
grant all on sakila.* to `sbtest_user`@`%`;
show grants for sbtest_user;
"""

# Run sysbench OLTP read and write tests
"""
# prepare
sysbench --db-driver=mysql --mysql-user=sbtest_user --mysql_password=password --mysql-db=sakila --mysql-host=localhost --mysql-port=3306 --tables=16 --table-size=10000 /usr/share/sysbench/oltp_read_write.lua prepare
# run
sysbench --db-driver=mysql --mysql-user=sbtest_user --mysql_password=password --mysql-db=sakila --mysql-host=localhost --mysql-port=3306 --threads=8 --time=300 --events=0 --report-interval=1 --rate=40 /usr/share/sysbench/oltp_read_write.lua run

"""