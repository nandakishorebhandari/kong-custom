#!/bin/sh

# docker rm -f kong-service
# docker rmi -f kong-service
# docker build -t kong-service .
# docker run -it --name kong-service --env-file ./dev.env -p 8001:8001 -p 8000:8000 kong-service



docker rm -f kong-database
docker rmi -f kong-database
docker rm -f kong-service
docker rmi -f kong-service
sudo fuser -k 5432/tcp
docker run -d --name kong-database   -p 5432:5432  -e "POSTGRES_USER=kong"  -e "POSTGRES_DB=kong"   postgres:9.4
docker run --rm --link kong-database:kong-database -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" kong-service


docker build --no-cache -t kong-service .

docker run -d --name kong-service  --link kong-database:kong-database   --env-file ./dev.env -p 8001:8001 -p 8000:8000 kong-service

sudo bash ./add_apis.sh


# KONG_DATABASE=postgres
# KONG_PG_HOST=kong-database


#Success when connected wifi
# 2017/12/27 09:04:14 [debug] starting serf agent: nohup serf agent -profile 'wan' -rpc-addr '127.0.0.1:7373' -event-handler 'member-join,member-leave,member-failed,member-update,member-reap,user:kong=/usr/local/kong/serf/serf_event.sh' -bind '0.0.0.0:7945' -node '60f693108ea3_0.0.0.0:7945_9c4dffbeb2b64dbf9d243b299648d314' -log-level 'err'> /usr/local/kong/logs/serf.log 2>&1 & echo $! > /usr/local/kong/pids/serf.pid
# 2017/12/27 09:04:14 [verbose] waiting for serf agent to be running
# 2017/12/27 09:04:15 [debug] sending signal to pid at: /usr/local/kong/pids/serf.pid
# 2017/12/27 09:04:15 [debug] kill -0 `cat /usr/local/kong/pids/serf.pid` >/dev/null 2>&1
# 2017/12/27 09:04:15 [verbose] serf agent started
# 2017/12/27 09:04:16 [verbose] auto-joining serf cluster
# 2017/12/27 09:04:19 [verbose] no other nodes found in the cluster
# 2017/12/27 09:04:19 [verbose] registering serf node in datastore
# 2017/12/27 09:04:28 [verbose] cluster joined and node registered in datastore
# 2017/12/27 09:04:28 [debug] searching for OpenResty 'nginx' executable
# 2017/12/27 09:04:28 [debug] /usr/local/openresty/nginx/sbin/nginx -v: 'nginx version: openresty/1.11.2.1'
# 2017/12/27 09:04:28 [debug] found OpenResty 'nginx' executable at /usr/local/openresty/nginx/sbin/nginx
# 2017/12/27 09:04:28 [debug] starting nginx: /usr/local/openresty/nginx/sbin/nginx -p /usr/local/kong -c nginx.conf
# ^C2017/12/27 09:07:01 [debug] nginx started
# 2017/12/27 09:07:01 [info] Kong started

#Failed when connected to LAN
# 2017/12/27 09:38:16 [debug] starting nginx: /usr/local/openresty/nginx/sbin/nginx -p /usr/local/kong -c nginx.conf
# 2017/12/27 09:38:21 [verbose] could not start Kong, stopping services
# 2017/12/27 09:38:21 [verbose] leaving serf cluster
# 2017/12/27 09:38:41 [verbose] left serf cluster
# 2017/12/27 09:38:41 [verbose] stopping serf agent at /usr/local/kong/pids/serf.pid
# 2017/12/27 09:38:41 [debug] sending signal to pid at: /usr/local/kong/pids/serf.pid
# 2017/12/27 09:38:41 [debug] kill -15 `cat /usr/local/kong/pids/serf.pid` >/dev/null 2>&1
# 2017/12/27 09:38:41 [verbose] serf agent stopped
# 2017/12/27 09:38:41 [verbose] stopping dnsmasq at /usr/local/kong/pids/dnsmasq.pid
# 2017/12/27 09:38:41 [debug] sending signal to pid at: /usr/local/kong/pids/dnsmasq.pid
# 2017/12/27 09:38:41 [debug] kill -15 `cat /usr/local/kong/pids/dnsmasq.pid` >/dev/null 2>&1
# 2017/12/27 09:38:41 [verbose] stopped services
# Error:
# /usr/local/share/lua/5.1/kong/cmd/start.lua:37: /usr/local/share/lua/5.1/kong/cmd/start.lua:23: nginx: [emerg] host not found in syslog server "kong-hf.mashape.com:61828" in /usr/local/kong/nginx.conf:21

# stack traceback:
#         [C]: in function 'error'
#         /usr/local/share/lua/5.1/kong/cmd/start.lua:37: in function 'cmd_exec'
#         /usr/local/share/lua/5.1/kong/cmd/init.lua:89: in function </usr/local/share/lua/5.1/kong/cmd/init.lua:89>
#         [C]: in function 'xpcall'
#         /usr/local/share/lua/5.1/kong/cmd/init.lua:89: in function </usr/local/share/lua/5.1/kong/cmd/init.lua:45>
#         /usr/local/bin/kong:13: in function 'file_gen'
#         init_worker_by_lua:40: in function <init_worker_by_lua:38>
#         [C]: in function 'pcall'
#         init_worker_by_lua:47: in function <init_worker_by_lua:45>
# Waiting for Kong to start...