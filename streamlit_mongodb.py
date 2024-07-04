import os
import re
import streamlit as st
from bson import ObjectId
from dotenv import load_dotenv
from pymongo import MongoClient
from streamlit_option_menu import option_menu

# Load environment variables from .env file
load_dotenv()

# Function to establish MongoDB connection
def connect_to_mongo():
    try:
        client = MongoClient(
            host=os.getenv('MONGO_HOST'),
            port=int(os.getenv('MONGO_PORT')),
            serverSelectionTimeoutMS=5000  # 5 seconds timeout
        )

        # Attempt to connect to the server to trigger any connection errors
        client.server_info()

        db = client[os.getenv('MONGO_DB')]
        st.success("Connected to MongoDB database")

        return db

    except Exception as e:
        st.error(f"Error connecting to MongoDB: {e}")
        return None

# Function to check if collection already exists
def check_collection_exists(db, collection_name):
    if not collection_name:
        st.warning("Please enter a collection name")
        return False

    collection_list = db.list_collection_names()
    return collection_name in collection_list

# Function to create a collection
def create_collection(db, collection_name):
    if not collection_name:
        st.warning("Please enter a collection name")
        return

    try:
        db.create_collection(collection_name)
        st.success(f"Collection '{collection_name}' created")
    except Exception as e:
        st.error(f"Error creating collection '{collection_name}': {e}")

def main():
    st.title("Streamlit with MongoDB")

    selected = option_menu(
        menu_title=None,
        options=["Home", "CRUD"],
        icons=["house-fill", "database-fill"],  # https://icons.getbootstrap.com/
        orientation="horizontal",
    )

    if selected == "Home":
        st.write("Welcome to MongoDB CRUD Operations")

    elif selected == "CRUD":
        db = connect_to_mongo()
        if db is None:
            st.warning("Please check the connection parameters")
            st.stop()

        collection_name = st.text_input("Enter Collection Name to Connect or Create if not Exists")

        if st.button("Connect / Create Collection"):
            if check_collection_exists(db, collection_name):
                st.write(f"Collection '{collection_name}' already exists and connected")
            else:
                create_collection(db, collection_name)

        collection = db[collection_name]

        operation = st.sidebar.selectbox("Select an Operation", (
            "INSERT",
            "Find",
            "Update",
            "Delete"))

        match operation:
            case "INSERT":
                st.subheader("Insert a Record")

                usr_name = st.text_input("Enter Name")
                usr_email = st.text_input("Enter Email")

                if st.button("Insert a Record"):
                    if usr_name and usr_email:
                        if not re.match(r"[^@]+@[^@]+\.[^@]+", usr_email):
                            st.warning("Invalid email format")
                            return
                        else:
                            # Generate a new unique ID
                            new_id = str(ObjectId())

                            # Insert the record with the generated ID
                            collection.insert_one({"_id": new_id, "name": usr_name, "email": usr_email})
                            st.success("Record inserted")
                    else:
                        st.warning("Please enter both name and email to insert a record")

            case "Find":
                st.subheader("Find Records")

                try:
                    records = list(collection.find({}, {"_id": 1, "name": 1, "email": 1})) # to include _id: 1 (to include _id)
                    if records:
                        for record in records:
                            record['_id'] = str(record['_id'])
                        st.dataframe(records)
                    else:
                        st.info("No records found.")
                except Exception as e:
                    st.error(f"Error finding records: {e}")

            case "Update":
                st.subheader("Update a Record")

                record_id = st.text_input("Enter Record ID")
                usr_name = st.text_input("Enter New Name")
                usr_email = st.text_input("Enter New Email")

                if st.button("Update Record"):
                    update_fields = {}
                    if usr_name:
                        update_fields["name"] = usr_name
                    if usr_email:
                        if not re.match(r"[^@]+@[^@]+\.[^@]+", usr_email):
                            st.warning("Invalid email format")
                            return
                        update_fields["email"] = usr_email

                    if update_fields:
                        result = collection.update_one({"_id": ObjectId(record_id)}, {"$set": update_fields})
                        if result.modified_count:
                            st.success("Record Updated")
                        else:
                            st.warning("No record found with the specified ID")
                    else:
                        st.warning("Please enter a name or email to update")

            case "Delete":
                st.subheader("Delete a Record")

                record_id = st.text_input("Enter Record ID")

                if st.button("Delete Record"):
                    result = collection.delete_one({"_id": ObjectId(record_id)})
                    if result.deleted_count:
                        st.warning("Record Deleted")
                    else:
                        st.warning("No record found with the specified ID")

            case _:
                raise ValueError("Operation not supported")
    else:
        raise ValueError("Menu option not defined")

if __name__ == "__main__":
    main()
