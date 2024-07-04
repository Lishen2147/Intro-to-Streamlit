#!/bin/bash

# Stop PostgreSQL service
sudo systemctl stop postgresql

if [ $? -eq 0 ]; then
    echo "PostgreSQL service stopped successfully."
else
    echo "Failed to stop PostgreSQL service or service already stopped."
fi

# Remove PostgreSQL packages
sudo apt-get --purge remove postgresql postgresql-*

if [ $? -eq 0 ]; then
    echo "PostgreSQL packages removed successfully."
else
    echo "Failed to remove PostgreSQL packages."
fi

# Remove PostgreSQL configuration and data files
sudo rm -rf /etc/postgresql/ /etc/postgresql-common/ /var/lib/postgresql/ /var/log/postgresql/ /var/run/postgresql/

if [ $? -eq 0 ]; then
    echo "PostgreSQL configuration and data files removed successfully."
else
    echo "Failed to remove PostgreSQL configuration and data files."
fi

# Remove PostgreSQL user and group
sudo deluser postgres
sudo delgroup postgres

if [ $? -eq 0 ]; then
    echo "PostgreSQL user and group removed successfully."
else
    echo "Failed to remove PostgreSQL user and group."
fi

# Remove any dependencies that are no longer required
sudo apt-get autoremove

if [ $? -eq 0 ]; then
    echo "All dependencies removed successfully."
else
    echo "Failed to remove dependencies."
fi

# Update the package list
sudo apt-get update

if [ $? -eq 0 ]; then
    echo "Package list updated successfully."
else
    echo "Failed to update package list."
fi

# Finished
echo "PostgreSQL has been completely removed from your system."
