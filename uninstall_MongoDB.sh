#!/bin/bash

echo "Stopping MongoDB service..."
sudo systemctl stop mongod

if [ $? -eq 0 ]; then
    echo "MongoDB service stopped successfully."
else
    echo "Failed to stop MongoDB service or service already stopped."
fi

echo "Removing MongoDB packages..."
sudo apt-get purge -y mongodb-org*

if [ $? -eq 0 ]; then
    echo "MongoDB packages removed successfully."
else
    echo "Failed to remove MongoDB packages."
fi

echo "Removing MongoDB configuration and data files..."
sudo rm -rf /var/log/mongodb
sudo rm -rf /var/lib/mongodb

if [ $? -eq 0 ]; then
    echo "MongoDB configuration and data files removed successfully."
else
    echo "Failed to remove MongoDB configuration and data files."
fi

echo "Removing MongoDB dependencies..."
sudo apt-get autoremove -y
sudo apt-get autoclean

if [ $? -eq 0 ]; then
    echo "MongoDB dependencies removed successfully."
else
    echo "Failed to remove MongoDB dependencies."
fi

echo "MongoDB has been completely removed from your system."
