#!/bin/bash

sudo apt update
sudo apt install -y net-tools
cd ~
wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
tar -xvf mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
sudo apt install libclass-methodmaker-perl

sudo dpkg -i mysql-cluster-community-data-node_8.0.30-1ubuntu22.04_amd64.deb

# Create config file to add manager
sudo mkdir /etc/mysql/
# sudo nano /etc/mysql/my.cnf
sudo mkdir -p /usr/local/mysql/data
# sudo ndbd
# sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini