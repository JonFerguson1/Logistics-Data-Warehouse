# Logistics_data_warehouse
Data warehouse that receives data from CSV files based on scheduling from Apache Airflow.
- This project was created in a Linux environment using Windows SubSystem for Linux. 
- MySQL and Airflow should be installed.The SQL files are meant to setup the database. 
- Once the database is setup then there is no more need for the SQL files. 
- Data in the CSV files have the below column headers from the raw data files.

Primary Reference,Owner,Customer Charge,Customer Mode,Carrier Name,Carrier Charge,Equipment,Actual Ship,Origin Name,Origin Addr1,Origin Addr2,Origin City,Origin State,Origin Zip,Origin Ctry,Actual Delivery,Dest Name,Dest Addr1,Dest Addr2,Dest City,Dest State,Dest Zip,Dest Ctry,Quantity ShipUnit,Weight

- Airflow dag is set to start 04/01/2022 and performs weekly. Adds new data from CSV files into the data warehouse. 
- The logistics.py script is run by the BashOperator in the dag due to issues with the PythonOperator.
- Create an empty log file "logistics_logfile.txt".
- For your database.py file make sure to input your database connection info.

![Logistics_Data_Warehouse](https://user-images.githubusercontent.com/73361532/161411750-c6f52031-ddd5-4f45-bf1d-50dd7dfd00a4.JPG)
