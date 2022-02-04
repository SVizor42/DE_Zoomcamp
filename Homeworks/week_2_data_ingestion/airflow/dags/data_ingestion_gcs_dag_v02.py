import os
from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

from utils import format_to_parquet, upload_to_gcs


PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")

dataset_file = 'yellow_tripdata_{{ execution_date.strftime(\'%Y-%m\') }}.csv'
dataset_url = f'https://s3.amazonaws.com/nyc-tlc/trip+data/{dataset_file}'
path_to_local_home = os.environ.get('AIRFLOW_HOME', '/opt/airflow/')
parquet_file = dataset_file.replace('.csv', '.parquet')


default_args = {
    "owner": "airflow",
    "start_date": datetime(2019, 1, 1),
    "end_date": datetime(2020, 12, 31),
    "depends_on_past": False,
    "retries": 1,
}

# NOTE: DAG declaration - using a Context Manager (an implicit way)
with DAG(
    dag_id="data_ingestion_gcs_dag_v02",
    schedule_interval="@monthly",
    default_args=default_args,
    catchup=True,
    max_active_runs=3,
    tags=['dtc-de'],
) as dag:

    download_dataset_task = BashOperator(
        task_id="download_dataset_task",
        bash_command=f"curl -sSLf {dataset_url} > {path_to_local_home}/{dataset_file}"
    )

    format_to_parquet_task = PythonOperator(
        task_id="format_to_parquet_task",
        python_callable=format_to_parquet,
        op_kwargs={
            "src_file": f"{path_to_local_home}/{dataset_file}",
        },
    )

    local_to_gcs_task = PythonOperator(
        task_id="local_to_gcs_task",
        python_callable=upload_to_gcs,
        op_kwargs={
            "bucket": BUCKET,
            "object_name": f"raw/yellow_taxi_trips/{parquet_file}",
            "local_file": f"{path_to_local_home}/{parquet_file}",
        },
    )

    download_dataset_task >> format_to_parquet_task >> local_to_gcs_task
