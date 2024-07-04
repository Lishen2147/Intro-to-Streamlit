#!/bin/bash

# Prompt for PostgreSQL admin password and database user password
read -sp 'Enter PostgreSQL admin password: ' postgres_password
echo
read -sp 'Enter PostgreSQL user password: ' user_password
echo

# Update the package index
sudo apt update

# Install PostgreSQL
sudo apt-get install -y postgresql postgresql-contrib

# Switch to the postgres user and create a new PostgreSQL user
sudo -u postgres psql -c "CREATE USER streamlit_user WITH PASSWORD '$user_password';"

# Create a new PostgreSQL database and grant privileges to the user
sudo -u postgres psql -c "CREATE DATABASE streamlit_db;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE streamlit_db TO streamlit_user;"

# Modify PostgreSQL authentication methods to use passwords
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf > /dev/null

# Restart PostgreSQL for changes to take effect
sudo systemctl restart postgresql

# Output PostgreSQL connection parameters to .env file
if ! grep -q "POSTGRES_HOST=" .env; then
    echo "POSTGRES_HOST=localhost" >> .env
else
    sed -i 's/^POSTGRES_HOST=.*/POSTGRES_HOST=localhost/' .env
fi

if ! grep -q "POSTGRES_PORT=" .env; then
    echo "POSTGRES_PORT=5432" >> .env
else
    sed -i 's/^POSTGRES_PORT=.*/POSTGRES_PORT=5432/' .env
fi

if ! grep -q "POSTGRES_USER=" .env; then
    echo "POSTGRES_USER=streamlit_user" >> .env
else
    sed -i 's/^POSTGRES_USER=.*/POSTGRES_USER=streamlit_user/' .env
fi

if ! grep -q "POSTGRES_PASSWORD=" .env; then
    echo "POSTGRES_PASSWORD=$user_password" >> .env
else
    sed -i "s/^POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$user_password/" .env
fi

if ! grep -q "POSTGRES_DB=" .env; then
    echo "POSTGRES_DB=streamlit_db" >> .env
else
    sed -i 's/^POSTGRES_DB=.*/POSTGRES_DB=streamlit_db/' .env
fi

# Print success message
echo "PostgreSQL connection parameters written to .env file."

# Install required Python packages
pip install psycopg2-binary streamlit streamlit-option-menu python-dotenv
npm i bootstrap-icons

echo "Python dependencies installed successfully."

echo "Installation and configuration complete. You can now run your Streamlit application."

echo -e "Run this command to start your Streamlit application: \e[32mstreamlit run streamlit_postgresql.py\e[0m"
