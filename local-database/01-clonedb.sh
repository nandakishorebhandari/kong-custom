#!/bin/sh

# Setup psql-client tools to dump and load 
# sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# sudo apt-get update
# sudo apt-get install postgresql-9.6

# Clone prod db to local db by running local docker image of postgress
# docker stop dbdump
# fuser -k 5432/tcp
# docker rm dbdump
# docker run -d --name dbdump  -p 5432:5432 postgres:9.6
# while ! curl http://localhost:5432/ 2>&1 | grep '52'
# do
#   sleep 1
# done
# sleep 5

# Source RDS Instance details- PRODUCTION
export SOURCE_DB_HOST="insighter-prod.cccvzbrq3rah.us-east-1.rds.amazonaws.com"
export SOURCE_DB_PORT="5432"
export SOURCE_DB_ADMIN_USERNAME=""
export SOURCE_DB_ADMIN_PASSWORD=""

#Target RDS Instance details - TEST
# export TARGET_DB_HOST="bitmed-prod-dr-test.cccvzbrq3rah.us-east-1.rds.amazonaws.com"
# export TARGET_DB_PORT="5432"
# export TARGET_DB_ADMIN_USERNAME="bitmed_admin_prod"
# export TARGET_DB_ADMIN_PASSWORD="clvcbcrh8ibo"

#Target RDS Instance details - PROD DR
# export TARGET_DB_HOST="bitmedprod.cccvzbrq3rah.us-east-1.rds.amazonaws.com"
# export TARGET_DB_PORT="5432"
# export TARGET_DB_ADMIN_USERNAME="bitmed_admin_prod"
# export TARGET_DB_ADMIN_PASSWORD="clvcbcrh8ibo"


# Target Locaal DB details
export TARGET_DB_HOST="localhost"
export TARGET_DB_PORT="5432"
export TARGET_DB_ADMIN_USERNAME="postgres"
export TARGET_DB_ADMIN_PASSWORD=""

#List of service:env:db-name:db-uesrname:db-password 
PROD_DB_SERVICE_LIST=(
# "auth:ins_auth:ins_user_auth:k7BnqU2jqnxqy1:bitmed_auth_user:bitmed_auth_pass"
# "cases:ins_cases:ins_user_cases:m7BqnU1nshq4q:bitmed_auth_user:bitmed_auth_pass"
# "user:ins_user:ins_user_user:pBqn61Bnqyc61:bitmed_auth_user:bitmed_auth_pass"
# "chat_proxy:ins_chat_proxy:ins_user_chat_proxy:d51mx8aHqus1:bitmed_auth_user:bitmed_auth_pass"
# "chat:ins_chat:ins_user_chat:rE3mq810sq9L:bitmed_auth_user:bitmed_auth_pass"
# "file:ins_file:ins_user_file:8ndW7ethkCzNUQrF:bitmed_auth_user:bitmed_auth_pass"
# "resource:ins_resource:ins_user_resource:rMa19akeiJqhd7:bitmed_auth_user:bitmed_auth_pass"
# "scheduler:ins_scheduler:ins_user_scheduler:Gqbsa71hsy100:bitmed_auth_user:bitmed_auth_pass"
"kong:kong:kong:u71BnqmYu31Lq:bitmed_auth_user:bitmed_auth_pass"
)

for DATABASE_DETAILS in ${PROD_DB_SERVICE_LIST[@]};
do
 tmp_details=(${DATABASE_DETAILS//:/ })
    echo "Type ${tmp_details[0]} ${tmp_details[1]}  ${tmp_details[2]}"
    # set -x
         ./02-dumpdp.sh ${tmp_details[0]} ${tmp_details[1]}  ${tmp_details[2]} ${tmp_details[3]}  ${tmp_details[4]} ${tmp_details[5]} 
    # set +x
done



