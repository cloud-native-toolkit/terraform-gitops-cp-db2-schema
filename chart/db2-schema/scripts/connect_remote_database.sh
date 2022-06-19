#!/usr/bin/env bash

DATABASE_HOST="$1"
DATABASE_PORT="$2"
DATABASE_DATABASE="$3"
DATABASE_USERNAME="$4"
DATABASE_PASSWORD="$5"

set -e

echo -n "** Running as "
whoami

echo "Creating connection to database: name=${DATABASE_DATABASE}, ${DATABASE_HOST}:${DATABASE_PORT}"

db2 catalog tcpip node prvsndb2 remote "${DATABASE_HOST}" server "${DATABASE_PORT}" SECURITY SSL;
db2 catalog db "${DATABASE_DATABASE}" as "${DATABASE_DATABASE}" at node prvsndb2;
db2 terminate;
db2 connect to "${DATABASE_DATABASE}" user "${DATABASE_USERNAME}" using "${DATABASE_PASSWORD}";
