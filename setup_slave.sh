#!/bin/bash

sudo apt update
cd ~
wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
tar -xvf mysql-cluster_8.0.30-1ubuntu22.04_amd64.deb-bundle.tar
apt install libclass-methodmaker-perl

sudo dpkg -i mysql-cluster-community-data-node_8.0.30-1ubuntu22.04_amd64.deb

sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini