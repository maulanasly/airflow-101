from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from sqlalchemy_utils.types.enriched_datetime.pendulum_date import pendulum

default_args = {
    "retries": 1,
}

OCTO_DB_CONN_ID = "airflow_101_pg"

SCHEMA_TABLES = [
    "dim_customers",
    "fact_order_accumulating",
    "dim_date",
]


with DAG(
    dag_id="soal_1_initial_dag",
    start_date=datetime(2022, 1, 1, tzinfo=pendulum.timezone("Asia/Jakarta")),
    schedule_interval=None,
    max_active_runs=1,
    catchup=False,
    tags=["case"],
    default_args=default_args,
) as dag:

    start_task = EmptyOperator(task_id="start")

    import_dateset = PostgresOperator(
        task_id=f"import_dateset",
        sql=f"queries/assignments/soal-1.sql",
        postgres_conn_id=OCTO_DB_CONN_ID,
    )

    create_schema_tasks = []
    for table in SCHEMA_TABLES:

        create_schema = PostgresOperator(
            task_id=f"create_{table}_schema",
            sql=f"queries/schemas/{table}.sql",
            postgres_conn_id=OCTO_DB_CONN_ID,
        )
        create_schema_tasks.append(create_schema)

    populate_date_dimension = PostgresOperator(
        task_id=f"populate_date_dimension",
        sql=f"queries/date_dimension.sql",
        postgres_conn_id=OCTO_DB_CONN_ID,
    )

    end_task = EmptyOperator(task_id="end")

    start_task >> import_dateset >> create_schema_tasks
    create_schema_tasks >> populate_date_dimension >> end_task
