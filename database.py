import mysql.connector

pw = '' # Your MySQL password here
host = '' 
user = '' # Your MySQL user name here

config = {
    'user': user,
    'password': pw,
    'host': host
}

db = mysql.connector.connect(**config)
cursor = db.cursor()

