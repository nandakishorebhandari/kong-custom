#!/bin/sh

DB_SERVICE=$1
DB_TARGET_NAME=$2
DB_SOURCE_NAME=$2
DB_SOURCE_USER_NAME=$3
DB_SOURCE_USER_PASS=$4
DB_TARGET_USER_NAME=$5
DB_TARGET_USER_PASS=$6
DB_SOURCE_DIR='source_dump'
DB_SOURCE_DUMP_FILE=$DB_SOURCE_DIR/"${DB_SOURCE_NAME}_dump"
PATH_INITIAL_SETUP='initial-db-setup'

echo "$DB_SERVICE $DB_SOURCE_NAME $DB_TARGET_NAME $DB_SOURCE_USER_NAME $DB_SOURCE_USER_PASS $DB_TARGET_USER_NAME $DB_TARGET_USER_PASS"

# Connect to source resource
export PGHOST=$SOURCE_DB_HOST
export PGPORT=$SOURCE_DB_PORT
export PGDATABASE=$DB_SOURCE_NAME
export PGUSER=$DB_SOURCE_USER_NAME
export PGPASSWORD=$DB_SOURCE_USER_PASS

# Remove  previous dbump file
rm $DB_SOURCE_DUMP_FILE
# Create dump file
pg_dump $DB_SOURCE_NAME -x -s --no-owner  > $DB_SOURCE_DUMP_FILE;

# Connect to target resource
export PGHOST=$TARGET_DB_HOST
export PGPORT=$TARGET_DB_PORT
export PGDATABASE='postgres'
export PGUSER=$TARGET_DB_ADMIN_USERNAME
export PGPASSWORD=$TARGET_DB_ADMIN_PASSWORD

# Create DB user for respective service
psql -c "create user  ${DB_TARGET_USER_NAME} with password '${DB_TARGET_USER_PASS}'";

# Terminate existing connections if available
psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${DB_TARGET_NAME}' AND pid <> pg_backend_pid()";

# Drop DB if available
dropdb $DB_TARGET_NAME;

#Create DB for respective service

if [ "$DB_SERVICE" != "kong" ]; then 
echo "$DB_SERVICE"
createdb $DB_TARGET_NAME;  
#Create schema and load data from dump file 
psql -d  $DB_TARGET_NAME <$DB_SOURCE_DUMP_FILE

#Anonymise PII data using respective scrub file
psql -d  $DB_TARGET_NAME -f $PATH_INITIAL_SETUP/$DB_SERVICE/$DB_SERVICE'_scrub.sql';

# Grant privellages to created user, public and owner for DB and Tables
psql -c "GRANT CONNECT, TEMPORARY ON DATABASE  ${DB_TARGET_NAME}   TO public";
psql -c "GRANT ALL ON DATABASE ${DB_TARGET_NAME}  TO $PGUSER";
psql -c "GRANT ALL ON DATABASE  ${DB_TARGET_NAME}  TO ${DB_TARGET_USER_NAME} ";
psql -d $DB_TARGET_NAME -c "GRANT ALL ON ALL TABLES IN SCHEMA public  TO ${DB_TARGET_USER_NAME} ";
psql -d $DB_TARGET_NAME -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DB_TARGET_USER_NAME}";
else 
# only for Kong DB 
psql -c  "GRANT  ${DB_TARGET_USER_NAME} TO ${PGUSER}"; 
psql -c  "CREATE DATABASE ${DB_TARGET_NAME} WITH OWNER = ${DB_TARGET_USER_NAME}";
createdb $DB_TARGET_NAME;  
fi