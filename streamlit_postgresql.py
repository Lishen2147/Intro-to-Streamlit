import psycopg2
import streamlit as st
import os
import re
from dotenv import load_dotenv
from streamlit_option_menu import option_menu

# Load environment variables from .env file
load_dotenv()

# Function to establish PostgreSQL connection
def connect_to_postgresql():
    try:
        conn = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            host=os.getenv('POSTGRES_HOST'),
            port=os.getenv('POSTGRES_PORT'),
            database=os.getenv('POSTGRES_DB')
        )
        st.success("Connected to PostgreSQL database")
        return conn
    except Exception as e:
        st.error(f"Error connecting to PostgreSQL: {e}")
        return None

# Function to check if table already exists
def check_table_exists(cursor, table_name):
    if table_name is None:
        st.warning("Please enter a table name")
        return

    cursor.execute(f"SELECT * FROM information_schema.tables WHERE table_name = '{table_name}'")
    return cursor.fetchone()

# Function to create a table
def create_table(conn, cursor, table_name):
    if not table_name:
        st.warning("Please enter a table name")
        return

    cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255),
        email VARCHAR(255)
        )
    """)

    conn.commit()
    st.success(f"Table '{table_name}' created")

def main():
    st.title("Streamlit with PostgreSQL")

    selected = option_menu(
        menu_title = None,
        options = ["Home", "CRUD"],
        icons = ["house-fill", "database-fill"], # https://icons.getbootstrap.com/
        orientation = "horizontal",

    )

    if selected == "Home":
        st.write("Welcome to PostgreSQL CRUD Operations")

    elif selected == "CRUD":
        conn = connect_to_postgresql()
        if conn is None:
            st.warning("Please check the connection parameters")
            st.stop()

        cursor = conn.cursor()

        table_name = st.text_input("Enter Table Name to Connect or Create if not Exists")

        if st.button("Connect / Create Table"):
            if check_table_exists(cursor, table_name):
                st.write(f"Table '{table_name}' already Exists and Connected")
            else:
                create_table(conn, cursor, table_name)

        operation = st.sidebar.selectbox("Select an Operation",(
            "Create",
            "Read",
            "Update",
            "Delete"))

        match operation:
            case "Create":
                st.subheader("Create a Record")

                usr_name = st.text_input("Enter Name")
                usr_email = st.text_input("Enter Email")


                if st.button("Add Record"):
                    if usr_name and usr_email:
                        if not re.match(r"[^@]+@[^@]+\.[^@]+", usr_email):
                            st.warning("Invalid email format")
                            return
                        else:
                            cursor.execute(f"INSERT INTO {table_name} (name, email) VALUES (%s, %s)", (usr_name, usr_email))
                            conn.commit()
                            st.success("Record Added")
                    else:
                        st.warning("Please enter both name and email to create a record")

            case "Read":
                st.subheader("Read Records")

                if table_name is None:
                    st.warning("Please create a table first")
                    raise st.ScriptRunner.StopException
                else:
                    try:
                        cursor.execute(f"SELECT * FROM {table_name}")
                        records = cursor.fetchall()
                        if records:
                            st.dataframe(records)
                        else:
                            st.info("No records found.")
                    except psycopg2.connect.Error as e:
                        st.error(f"Error executing SQL query: {e}")

            case "Update":
                st.subheader("Update a Record")

                id = st.number_input("Enter ID", step=1, value=0, format="%d")
                usr_name = st.text_input("Enter Name")
                usr_email = st.text_input("Enter Email")

                if st.button("Update Record"):

                    if usr_name and usr_email:
                        if not re.match(r"[^@]+@[^@]+\.[^@]+", usr_email):
                            st.warning("Invalid email format")
                            return
                        else:
                            cursor.execute(f"UPDATE {table_name} SET name = %s, email = %s WHERE id = %s", (usr_name, usr_email, id))

                    elif usr_name:
                        cursor.execute(f"UPDATE {table_name} SET name = %s WHERE id = %s", (usr_name, id))

                    elif usr_email:
                        if not re.match(r"[^@]+@[^@]+\.[^@]+", usr_email):
                            st.warning("Invalid email format")
                            return
                        else:
                            cursor.execute(f"UPDATE {table_name} SET email = %s WHERE id = %s", (usr_email, id))

                    else:
                        st.warning("Please enter a name or email to update")
                        return

                    if cursor.rowcount == 0:
                        st.warning("No record found with the specified ID")
                        return
                    else:
                        conn.commit()
                        st.success("Record Updated")

            case "Delete":
                st.subheader("Delete a Record")

                id = st.number_input("Enter ID", step=1, value=0, format="%d")

                if st.button("Delete Record"):
                    cursor.execute(f"DELETE FROM {table_name} WHERE id = {id}")
                    if cursor.rowcount == 0:
                        st.warning("No record found with the specified ID")
                        return
                    else:
                        conn.commit()
                        st.warning("Record Deleted")
            case _:
                raise ValueError("Operation not supported")
    else:
        raise ValueError("Menu option not defined")

if __name__ == "__main__":
    main()
