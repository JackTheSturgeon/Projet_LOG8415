#!/bin/bash

sudo apt update
# Will use ifconfig to get the addr of manager
sudo apt install net-tools
cd ~
sudo wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
sudo tar -xvf mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
sudo dpkg -i mysql-cluster-community-management-server_8.0.30-1ubuntu22.04_amd64.deb

# First create the config.ini file
# This file contains the IPs of the slaves and the manager
sudo mkdir /var/lib/mysql-cluster
sudo mkdir /etc/mysql/
"""
sudo nano /etc/mysql/my.cnf
sudo nano /var/lib/mysql-cluster/config.ini

sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini

Setup ndb as a service
sudo pkill -f ndb_mgmd
sudo nano /etc/systemd/system/ndb_mgmd.service

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd

See the ports that are being listened to
sudo lsof -i -P -n | grep LISTEN 
"""

# CONFIGURATION DU CLIENT/SERVER MYSQL
# To install Custom MySQL server compatible with ndbd
sudo mkdir install
cd install
sudo wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster_8.0.31-1ubuntu22.04_amd64.deb-bundle.tar
sudo tar -xvf mysql-cluster_8.0.31-1ubuntu22.04_amd64.deb-bundle.tar

"""
sudo apt update
sudo dpkg -i mysql-common_8.0.31-1ubuntu22.04_amd64.deb

# Community client depends on these two
sudo dpkg -i mysql-cluster-community-client-plugins_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client-core_8.0.31-1ubuntu22.04_amd64.deb

sudo dpkg -i mysql-cluster-community-client_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-client_8.0.31-1ubuntu22.04_amd64.deb

# From here we need libmecab2 for this one (not automatable) --> dependency for the community server
sudo apt install -y libmecab2
sudo dpkg -i mysql-cluster-community-server-core_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_8.0.31-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-server_8.0.31-1ubuntu22.04_amd64.deb

sudo nano /etc/mysql/my.cnf
sudo systemctl enable mysql

"""