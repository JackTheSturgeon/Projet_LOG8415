#!/bin/bash

echo "setup starting" >> /var/log/user-data.log

sudo apt update
sudo apt install -y mysql-server