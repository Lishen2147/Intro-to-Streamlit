# streamlit_app.py

import streamlit as st

# Initialize connection.
conn = st.connection("postgresql", type="sql")

# Perform query.
df = conn.query('SELECT * FROM mytable;', ttl="10m") # ttl ensures the query result is cached for no longer than 10 minutes

# Print results.
for row in df.itertuples():
    st.write(f"{row.name} has a :{row.pet}:")