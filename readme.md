# Into to Streamlit with basic CRUD operations

## Database used:
- MySQL
- PostgreSQL
- MongoDB

## To run the app:
- MySQL
```bash
./install_MySQL.sh
streamlit run streamlit_mysql.py
```

- PostgreSQL
```bash
./install_PostgreSQL.sh
streamlit run streamlit_postgresql.py
```
- MongoDB
```bash
./install_MongoDB.sh
streamlit run streamlit_mongodb.py
```

## Cleanup:
if you want to remove the database and user created, run the following command:
```bash
./uninstall_MySQL.sh
```
or
```bash
./uninstall_PostgreSQL.sh
```
or
```bash
./uninstall_MongoDB.sh
```

***note***: These script would search and remove all the files starting with `mysql` or `postgresql` in the entire file system. So, be careful while running these scripts.
