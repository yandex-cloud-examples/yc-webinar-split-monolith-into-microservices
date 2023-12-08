#!/bin/bash

read -p "Enter registry ID: " REGISTRY_ID
read -p "Enter image tag: " TAG

docker build ../../monolith --tag cr.yandex/$REGISTRY_ID/monolith:$TAG
docker push cr.yandex/$REGISTRY_ID/monolith:$TAG
