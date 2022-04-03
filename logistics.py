import time
from datetime import datetime
import pandas as pd
import mysql.connector
from database import cursor, pw, host
import sqlalchemy
import glob
from flask_sqlalchemy import SQLAlchemy

# Database setup

DB_NAME = 'logistics_warehouse'
engine = sqlalchemy.create_engine('mysql+pymysql://{}:{}@{}/{}'.format(user, pw, host, DB_NAME))
logfile = "logistics_logfile.txt"

df = pd.DataFrame()

# For logging the ETL process

def log(message):
    timestamp_format = '%Y-%h-%d-%H:%M:%S' # Year-Monthname-Day-Hour-Minute-Second
    now = datetime.now() # get current timestamp
    timestamp = now.strftime(timestamp_format)
    with open(logfile,"a") as f:
        f.write(timestamp + ',' + message + '\n')

# Extracting each CSV

def extract_csv(file):
    dataframe = pd.read_csv(file)
    return dataframe

# Extracting all CSV

def extract():
    extracted_data = pd.DataFrame()

    for csvfile in glob.glob("*.csv"):
        extracted_data = extracted_data.append(extract_csv(csvfile), ignore_index = True)
        
    return extracted_data

# Transforming data

def transform(df):
    discard = ["Cancelled"]

    df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('(', '').str.replace(')', '') # converting column names to correct database format.

    df = df.convert_dtypes() 

    # Formatting to datetime and applying zipcode to strings.
    
    df['actual_ship'] = pd.to_datetime(df['actual_ship'])
    df['actual_delivery'] = pd.to_datetime(df['actual_delivery'])
    df['origin_zip'] = df['origin_zip'].apply(str)
    df['dest_zip'] = df['dest_zip'].apply(str)

    # Removing cancelled shipments from dataframe. Dropping rows with no charges, no ship/delivery data, and duplicate primary references.

    df = df[~df.primary_reference.str.contains('|'.join(discard))]
    df['carrier_charge'].dropna(axis=0, inplace=True)
    df['customer_charge'].dropna(axis=0, inplace=True)
    df['actual_ship'].dropna(axis=0, inplace=True)
    df['actual_delivery'].dropna(axis=0, inplace=True)
    df.drop_duplicates(subset="primary_reference", inplace = True)
    
    # Renaming columns to MySQL database columns.

    df = df.rename(columns={
        "primary_reference": "primary_ref", "owner": "customer_name",
        "origin_name": "ship_name", "origin_addr1": "ship_addr1", 
        "origin_addr2": "ship_addr2", "origin_city": "ship_city", 
        "origin_state": "ship_state", "origin_zip": "ship_zip",
        "origin_ctry": "ship_country", "dest_name": "rec_name", 
        "dest_addr1": "rec_addr1", "dest_addr2": "rec_addr2",
        "dest_city": "rec_city", "dest_state": "rec_state", 
        "dest_zip": "rec_zip", "dest_ctry": "rec_country", 
        "quantity_shipunit": "quantity"
    })

    # Assigning to new dataframes based on which table the data will be uploaded to.

    logistics = df['primary_ref']
    customer = df[['customer_name', 'customer_mode']]
    carrier = df[['carrier_name', 'equipment']]
    financial = df[['customer_charge', 'carrier_charge']]
    freight = df[['quantity', 'weight']]
    date_time = df[['actual_ship', 'actual_delivery']]
    shipping = df[[
        'ship_name', 'ship_addr1', 'ship_addr2', 'ship_city',
        'ship_state', 'ship_zip', 'ship_country']]
    receiving = df[[
        'rec_name', 'rec_addr1', 'rec_addr2', 'rec_city', 
        'rec_state', 'rec_zip', 'rec_country']]

    return logistics, customer, carrier, financial, freight, date_time, shipping, receiving

# Loading data into MySQL

def load(logistics, customer, carrier, financial, freight, date_time, shipping, receiving):
    cursor.execute("USE {}".format(DB_NAME))

    logistics.to_sql('logistics_fact', con=engine, index=False, if_exists='replace')
    customer.to_sql('customer_dim', con=engine, index=False, if_exists='replace')
    carrier.to_sql('carrier_dim', con=engine, index=False, if_exists='replace')
    date_time.to_sql('date_time_dim', con=engine, index=False, if_exists='replace')
    financial.to_sql('financial_dim', con=engine, index=False, if_exists='replace')
    shipping.to_sql('shipping_dim', con=engine, index=False, if_exists='replace')
    receiving.to_sql('receiving_dim', con=engine, index=False, if_exists='replace')
    freight.to_sql('freight_dim', con=engine, index=False, if_exists='replace')
    cursor.close()

    return

# Running ETL

def run_logistics_etl():
    log("ETL Job Started")
    log("Extract phase Started")

    extracted_data = extract()

    log("Extract phase Ended")
    log("Transform phase Started")

    logistics, customer, carrier, financial, freight, date_time, shipping, receiving = transform(extracted_data)

    log("Transform phase Ended")
    log("Load phase Started")

    load(logistics, customer, carrier, financial, freight, date_time, shipping, receiving)
    
    log("ETL Job Ended")

run_logistics_etl()
