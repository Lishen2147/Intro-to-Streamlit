#!/bin/bash

echo "Stopping MySQL service..."
sudo systemctl stop mysql

if [ $? -eq 0 ]; then
    echo "MySQL service stopped successfully."
else
    echo "Failed to stop MySQL service or service already stopped."
fi

echo "Removing MySQL packages..."
sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*

if [ $? -eq 0 ]; then
    echo "MySQL packages removed successfully."
else
    echo "Failed to remove MySQL packages."
fi

echo "Removing MySQL configuration and data files..."
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

if [ $? -eq 0 ]; then
    echo "MySQL configuration and data files removed successfully."
else
    echo "Failed to remove MySQL configuration and data files."
fi

echo "Removing MySQL dependencies..."
sudo apt-get autoremove -y
sudo apt-get autoclean

if [ $? -eq 0 ]; then
    echo "MySQL dependencies removed successfully."
else
    echo "Failed to remove MySQL dependencies."
fi

echo "MySQL has been completely removed from your system."