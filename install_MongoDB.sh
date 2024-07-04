#!/bin/bash

# Import MongoDB public GPG key and add repository
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# Reload local package database
sudo apt-get update

# Install MongoDB
sudo apt-get install -y mongodb-org

# Start MongoDB service
sudo systemctl start mongod

# Enable MongoDB service to start on boot
sudo systemctl enable mongod

# Print success message
echo "MongoDB has been installed and started successfully."

# Output MongoDB connection parameters to .env file
echo "MONGO_HOST=localhost" >> .env
echo "MONGO_PORT=27017" >> .env
echo "MONGO_DB=streamlit_db" >> .env

# Install required Python packages
pip install pymongo streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

# Print success message for Streamlit dependencies
echo "Python and npm dependencies installed successfully."

# Print the command to start the Streamlit application
echo -e "Run this command to start your Streamlit application: \e[32mstreamlit run streamlit_mongodb.py\e[0m"
