#!/bin/bash

# Downloading and installing dependencies for cluster data node
sudo apt update
sudo apt install -y net-tools
cd ~
wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
tar -xvf mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
sudo apt install libclass-methodmaker-perl
sudo dpkg -i mysql-cluster-community-data-node_8.0.30-1ubuntu22.04_amd64.deb

# Create config file to add manager node address to the configuration
sudo mkdir /etc/mysql/
"""
# Configuration file, we have to specify server addr
sudo nano /etc/mysql/my.cnf
"""
sudo mkdir -p /usr/local/mysql/data

# Launching the data node
"""
sudo ndbd
sudo pkill -f ndbd

# Commands to SETUP ndbd as a service
sudo nano /etc/systemd/system/ndbd.service
sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd
sudo systemctl status ndbd
"""