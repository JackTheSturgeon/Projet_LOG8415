#!/bin/bash

sudo apt update
# Will use ifconfig to get the addr of manager
sudo apt install net-tools
cd ~
wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
tar -xvf mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
sudo dpkg -i mysql-cluster-community-management-server_8.0.30-1ubuntu22.04_amd64.deb

# First create the config.ini file
# This file contains the IPs of the slaves and the manager
sudo mkdir /var/lib/mysql-cluster
sudo nano /var/lib/mysql-cluster/config.ini

sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini

sudo pkill -f ndb_mgmd
sudo nano /etc/systemd/system/ndb_mgmd.service

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd

sudo ufw allow from 3.236.224.252