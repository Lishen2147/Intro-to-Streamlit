# Intro-to-Streamlit

## Installation
Streamlit install: `pip install streamlit`
Check installation: `streamlit hello`
Run streamlit python script: `streamlit run your_script.py [-- script args]`

## Setup Postgres
following this link to install Postgres: https://www.tutorialspoint.com/postgresql/postgresql_environment.htm
Create a database
Type the following commands in SQL Shell `pqsl` to create a table
```
CREATE TABLE mytable (
    name            varchar(80),
    pet             varchar(80)
);

INSERT INTO mytable VALUES ('Mary', 'dog'), ('John', 'cat'), ('Robert', 'bird');
```

## Add username and password to your local app secrets
Your local Streamlit app will read secrets from a file `.streamlit/secrets.toml` in your app's root directory. Create this file if it doesn't exist yet and add the name, user, and password of your database as shown below:
```
# .streamlit/secrets.toml

[connections.postgresql]
dialect = "postgresql"
host = "localhost"
port = "5432"
database = "xxx"
username = "xxx"
password = "xxx"
```

## Copy your app secrets to the cloud
As the `secrets.toml` file above is not committed to GitHub, you need to pass its content to your deployed app (on Streamlit Community Cloud) separately. Go to the app dashboard (https://share.streamlit.io/) and in the app's dropdown menu, click on Edit Secrets. Copy the content of `secrets.toml` into the text area.

## Run the script
`streamlit run streamlit_postgres.py`