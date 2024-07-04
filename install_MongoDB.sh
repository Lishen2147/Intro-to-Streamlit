#!/bin/bash

# Import the public key used by the package management system
sudo apt-get install -y gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

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

# Create database named streamlit_db
mongo --eval "use streamlit_db"

# Output MongoDB connection parameters to .env file
if grep -q "MONGO_HOST=" .env; then
    sed -i 's/^MONGO_HOST=.*/MONGO_HOST=localhost/' .env
else
    echo "MONGO_HOST=localhost" >> .env
fi

if grep -q "MONGO_PORT=" .env; then
    sed -i 's/^MONGO_PORT=.*/MONGO_PORT=27017/' .env
else
    echo "MONGO_PORT=27017" >> .env
fi

if grep -q "MONGO_DB=" .env; then
    sed -i 's/^MONGO_DB=.*/MONGO_DB=streamlit_db/' .env
else
    echo "MONGO_DB=streamlit_db" >> .env
fi

# Install required Python packages
pip install pymongo streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

# Print success message for Streamlit dependencies
echo "Python and npm dependencies installed successfully."

# Print the command to start the Streamlit application
echo -e "Run this command to start your Streamlit application: \e[32mstreamlit run streamlit_mongodb.py\e[0m"
