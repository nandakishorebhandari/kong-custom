#!/bin/sh
# sudo bash ./kong-start.sh

echo "remove existing dockers"
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
echo "docker start"

#2. initialize environment
docker-compose down
echo "after docker down start"
docker-compose rm -f
echo "after docker compose remove"
docker-compose up --force-recreate -d
echo "after docker compose up"
cd ..
# terminator

sudo bash ./docker-entrypoint.sh
