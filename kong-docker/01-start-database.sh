#!/bin/sh

cd kong-docker

docker-compose down
echo "after docker down start"
docker-compose rm -f
echo "after docker compose remove"
docker-compose up --force-recreate -d 
echo "after docker compose up"
