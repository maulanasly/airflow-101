#!/bin/bash
echo "Deleting connections..."
airflow connections delete airflow_101_pg

echo $AIRFLOW__101_PORT

if [ -n "$AIRFLOW__101_HOST" ] && [ -n "$AIRFLOW__101_DB" ] && [ -n "$AIRFLOW__101_USER" ] && [ -n "$AIRFLOW__101_PORT" ] && [ -n "$AIRFLOW__101_PASSWORD" ]
then
  echo "Creating airflow_101_pg connection"
  airflow connections add --conn-type postgres \
                         --conn-host $AIRFLOW__101_HOST \
                         --conn-login $AIRFLOW__101_USER \
                         --conn-schema $AIRFLOW__101_DB \
                         --conn-port $AIRFLOW__101_PORT \
                         --conn-password $AIRFLOW__101_PASSWORD \
                         airflow_101_pg
fi
