#!/bin/sh
cd pgadmin4-docker
docker stop  local-pgadmin4
# docker volume create --driver local --name=pga4volume
docker build -t local-pgadmin4 .
docker run -d --net="host" -p 5050:5050  --volume=pga4volume:/var/lib/pgadmin  local-pgadmin4 