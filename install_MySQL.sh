#!/bin/bash

# Prompt for root password and user password
read -sp 'Enter MySQL root password: ' root_password
echo
read -sp 'Enter MySQL user password: ' user_password
echo

# Update the package index
sudo apt update

# Install MySQL Server
sudo apt install -y mysql-server

# Secure MySQL Installation
sudo mysql_secure_installation <<EOF

y
y
$root_password
$root_password
y
y
y
y
EOF

# Log in to MySQL as root and create database and user
sudo mysql -u root -p"$root_password" <<EOF
CREATE DATABASE streamlit_db;
CREATE USER 'streamlit_user'@'localhost' IDENTIFIED BY '$user_password';
GRANT ALL PRIVILEGES ON streamlit_db.* TO 'streamlit_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Print success message
echo "MySQL has been installed and configured successfully."

# Output PostgreSQL connection parameters to .env file
echo "MYSQL_USER=streamlit_user" >> .env
echo "MYSQL_PASSWORD=$user_password" >> .env
echo "MYSQL_DB=streamlit_db" >> .env

# Print success message
echo "PostgreSQL connection parameters written to .env file."

# Install required Python packages
pip install mysql-connector-python streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

echo "Python dependencies installed successfully."

echo "Installation and configuration complete. You can now run your Streamlit application."

echo "Run this command to start your Streamlit application: streamlit run streamlit_mysql.py"