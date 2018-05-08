#!/bin/sh

# docker rm -f kong-service
# docker rmi -f kong-service
# docker build -t kong-service .
# docker run -it --name kong-service --env-file ./dev.env -p 8001:8001 -p 8000:8000 kong-service

cd kong-docker

# docker rm -f kong-database
# docker rmi -f kong-database
docker rm -f kong-service
docker rmi -f kong-service
# sudo fuser -k 5433/tcp
# docker run -d --name kong-database   -p 5433:5433  -e "POSTGRES_USER=kong"  -e "POSTGRES_DB=kong"   postgres:9.4
# docker run --rm --link kong-database:kong-database -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" kong-service


docker build --no-cache -t kong-service .
docker run -d --net="host" --name kong-service --env-file ./dev.env -p 8001:8001 -p 8000:8000 kong-service
sudo bash ./add_apis.sh

