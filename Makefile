# default args
DOCKER_REGISTRY=local.registry
IMAGE_NAME=airflow_101
IMAGE_MAJOR_VERSION=0.0.1
IMAGE_TAG=latest


print:
	echo $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

build:
	docker build -t $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .
	docker tag $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

start:
	docker-compose -f local.yaml down && \
	docker-compose -f local.yaml build && \
	docker-compose -f local.yaml up

init-db:
	docker exec -it postgres psql -U airflow

add-connection:
	docker exec -it --user airflow airflow-webserver ./set_connections.sh
