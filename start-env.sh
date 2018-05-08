#!/bin/sh
# echo "remove existing dockers"
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
# echo "docker start"

sudo bash kong-docker/01-start-database.sh


sudo bash kong-docker/02-start-kong.sh

sudo bash pgadmin4-docker/start.sh
