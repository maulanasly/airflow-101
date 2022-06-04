# airflow-101

## How to setup
### Pre-requisite
- Install docker on local machine, visit [here](https://docs.docker.com/desktop/mac/install/) for the step.
- Run docker app
- Get inside the project directory and create `.env` file
```
>> touch .env
```
- Modify these config, then copy and paste into .env

```
# Meta-Database
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow

AIRFLOW__101_USER="{change me}"
AIRFLOW__101_PASSWORD="{change me}"
AIRFLOW__101_DB="{change me}"
AIRFLOW__101_HOST="{change me}"
AIRFLOW__101_PORT=5434

# Airflow Core
AIRFLOW__CORE__FERNET_KEY=UKMzEm3yIuFYEq1y3-2FxPNWSVwRASpahmQ9kQfEr8E=
AIRFLOW__CORE__EXECUTOR=LocalExecutor
AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True
AIRFLOW__CORE__LOAD_EXAMPLES=False
AIRFLOW_UID=0

# Backend DB
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@postgres/airflow
AIRFLOW__DATABASE__LOAD_DEFAULT_CONNECTIONS=False

# Airflow Init
_AIRFLOW_DB_UPGRADE=True
_AIRFLOW_WWW_USER_CREATE=True
_AIRFLOW_WWW_USER_USERNAME=airflow
_AIRFLOW_WWW_USER_PASSWORD=airflow
```
---
### 1. Run project for first assignment task
In order to run this project please follow these steps:
- Execute `make start`
```
>> make start
```
- Create database and user base on AIRFLOW__101.* credentials
```
>> make init-db

-- Once you're connected to database execute these commands
CREATE DATABASE {AIRFLOW__101_DB};
CREATE USER youruser WITH ENCRYPTED PASSWORD '{AIRFLOW__101_PASSWORD}';
GRANT ALL PRIVILEGES ON DATABASE {AIRFLOW__101_DB} TO {AIRFLOW__101_USER};
```
- Add new airflow postgres connection
```
>> make add-connection
```
This command will execute shell script which trigger airflow cli to add new connection to postgres database.

Once contaners up and running proceed with the following step
- Visit airflow web page on `localhost:8080`
- Enable `soal_1_initial_dag` and trigger it manually since we don't define the scheduled
- Enable `soal_1`, this dag has scheduled to be run at 7AM Asia/Jakarta but incase we need to see if it works we can always trigger it manually
---
### 2. Run project for second assignment task

The second task build using a python and mostly utilise built-in function. However, the extraction, transformaion and data cleansing use regex.
In order to run this script please execute this command:
```
./run.sh {json_file}

## Example
./run.sh ./scripts/soal-2.json
```

And will print out result into conlose, as example below:
```
1. lele 1936kg
2. mas 1176kg
3. tongkol 710kg
4. nila 696kg
5. kembung 282kg
6. kakap 256kg
...
```
