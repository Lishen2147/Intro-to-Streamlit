#!/bin/bash

# Stop PostgreSQL service
sudo systemctl stop postgresql

if [ $? -eq 0 ]; then
    echo "PostgreSQL service stopped successfully."
else
    echo "Failed to stop PostgreSQL service or service already stopped."
fi

# Remove PostgreSQL packages
sudo apt-get purge -y postgresql postgresql-contrib

if [ $? -eq 0 ]; then
    echo "PostgreSQL packages removed successfully."
else
    echo "Failed to remove PostgreSQL packages."
fi

# Remove PostgreSQL configuration and data files
sudo rm -rf /etc/postgresql /var/lib/postgresql

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

echo "PostgreSQL has been completely removed from your system."
