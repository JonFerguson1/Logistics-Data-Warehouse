from datetime import timedelta
from datetime import datetime
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago

from logistics import run_logistics_etl

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2022, 4, 1), # Update to your desired start date
    'email': ['someone@somemail.com'], # You can place your email here
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'schedule_interval': '@weekly', 
}

dag = DAG(
    'logistics_dag',
    default_args=default_args,
    description='Logistics dag to transfer data to MySQL datawarehouse',
    schedule_interval=timedelta(days=1)
)

run_etl = BashOperator(
    task_id='logistics_etl',
    bash_command='bash run_etl.sh',
    dag=dag
)

run_etl
