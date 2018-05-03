#!/bin/sh

function add_api {
 echo "Adding \"$1\" API"
 del_ret=$(curl -s -I -o /dev/null -w "%{http_code}" -X DELETE http://localhost:8001/apis/$1)
 if [ "$del_ret" = "204" ]; then
  echo "$del_ret: Old endpoint deleted"
 else
  echo "$del_ret: Old endpoint not found"
 fi

 add_ret=$(curl -s -i -o /dev/null -w "%{http_code}" -X POST http://localhost:8001/apis/ --data "name=$1" --data "upstream_url=$2" --data "request_path=$3" --data "strip_request_path=true")

 if [ "$add_ret" = "201" ]; then
  echo "$add_ret: Endpoint added"
 else
  echo "$add_ret: Endpoint didn't add"
 fi
}

function add_plugin {
 echo "Adding Plugin"
add_plu=$(curl -s -i -o /dev/null -w  "%{http_code}" -X POST http://localhost:8001/plugins --data "name=cors" --data "config.origin=*" --data "config.methods=GET,HEAD,PUT,PATCH,POST,DELETE" --data "config.headers=Content-Length,Authorization,Authentication,X-Requested-With, Content-MD5, Content-Type, Date, X-Auth-Token")
 
 if [ "$add_plu" = "201" ]; then
  echo "$add_plu: Plugin added"
 else
  echo "$add_plu: Plugin didn't add"
 fi
}

DOCKER_HOST=$(ip route get 1 | awk '{print $NF;exit}')
# DOCKER_HOST="192.168.1.146"
# DOCKER_HOST="192.168.1.146"
# DOCKER_HOST="192.168.0.103"
#  DOCKER_HOST="192.168.2.8";


echo 'Waiting for Kong to start...'

until [ $(curl -s -i -o /dev/null -w "%{http_code}" http://localhost:8001) == "200" ]
 do
  sleep 1
 done

# Add all service APIs
add_api auth		"http://$DOCKER_HOST:30001" /auth
add_api user		"http://$DOCKER_HOST:30005" /user
add_api case		"http://$DOCKER_HOST:30002" /case
add_api scheduler	"http://$DOCKER_HOST:30003" /scheduler
add_api resource	"http://$DOCKER_HOST:30004" /resource
add_api chat-proxy	"http://$DOCKER_HOST:8082" /chat
add_api file	    "http://$DOCKER_HOST:30007" /file

# Add cors API
add_plugin