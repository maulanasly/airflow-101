#!/bin/bash

# source airflow variable, which are fetched from Vault, in actual k8s environment
VARIABLE_ENV_FILE="/vault/secrets/airflow-variables.txt"
if [[ -f $VARIABLE_ENV_FILE ]]
then
  set -a; source $VARIABLE_ENV_FILE; set +a
fi

echo "Deleting connections..."
airflow connections delete airflow_101_pg


if [ -n "$AIRFLOW_VAR_CES_CLOUDSQL_HOST" ] && [ -n "$AIRFLOW_VAR_CES_CLOUDSQL_USER" ] && [ -n "$AIRFLOW_VAR_CES_CLOUDSQL_DB_NAME" ] && [ -n "$AIRFLOW_VAR_CES_CLOUDSQL_PORT" ] && [ -n "$AIRFLOW_VAR_CES_CLOUDSQL_PASSWORD" ]
then
  echo "Creating airflow_101_pg connection"
  airflow connections add --conn-type postgres \
                         --conn-host $AIRFLOW_VAR_CES_CLOUDSQL_HOST \
                         --conn-login $AIRFLOW_VAR_CES_CLOUDSQL_USER \
                         --conn-schema $AIRFLOW_VAR_CES_CLOUDSQL_DB_NAME \
                         --conn-port $AIRFLOW_VAR_CES_CLOUDSQL_PORT \
                         --conn-password $AIRFLOW_VAR_CES_CLOUDSQL_PASSWORD \
                         airflow_101_pg
fi
