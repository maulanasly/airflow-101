from airflow import DAG
from airflow.utils.helpers import chain
from sqlalchemy_utils.types.enriched_datetime.pendulum_date import pendulum
from airflow.providers.postgres.operators.postgres import PostgresOperator

from datetime import datetime


default_args = {
    "retries": 1,
}

OCTO_DB_CONN_ID = "airflow_101_pg"

DIMENSION_TABLES = [
    "customers",
    "fact_order_accumulating"
]


with DAG(
    dag_id='soal_1',
    start_date=datetime(2022, 1, 1, tzinfo=pendulum.timezone("Asia/Jakarta")),
    schedule_interval="0 7 * * *",
    max_active_runs=1,
    catchup=False,
    tags=["case"],
    default_args=default_args
) as dag:
    tasks = []
    for table in DIMENSION_TABLES:
        dimension_table = PostgresOperator(
            task_id=f"{table}_population",
            sql=f"queries/{table}.sql",
            postgres_conn_id=OCTO_DB_CONN_ID,
        )
        tasks.append(dimension_table)

    chain(*tasks)
