#!/bin/bash

# Prompt for root password and user password
echo "Define MySQL ROOT and STREAMLIT_USER passwords."
read -sp 'Enter your desired password for root: ' root_password
echo
read -sp 'Enter your desired password for streamlit_user: ' user_password
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

# Output PostgreSQL connection parameters to .env file if they don't exist
if ! grep -q "MYSQL_USER=" .env; then
    echo "MYSQL_USER=streamlit_user" >> .env
else
    sed -i 's/^MYSQL_USER=.*/MYSQL_USER=streamlit_user/' .env
fi

if ! grep -q "MYSQL_PASSWORD=" .env; then
    echo "MYSQL_PASSWORD=$user_password" >> .env
else
    sed -i "s/^MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$user_password/" .env
fi

if ! grep -q "MYSQL_DB=" .env; then
    echo "MYSQL_DB=streamlit_db" >> .env
else
    sed -i 's/^MYSQL_DB=.*/MYSQL_DB=streamlit_db/' .env
fi

# Print success message
echo "PostgreSQL connection parameters written to .env file."

# Install required Python packages
pip install mysql-connector-python streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

echo "Python dependencies installed successfully."

echo "Installation and configuration complete. You can now run your Streamlit application."

echo -e "Run this command to start your Streamlit application: \e[32mstreamlit run streamlit_mysql.py\e[0m"