#!/usr/bin/env sh

DATABASE_HOST="$1"
DATABASE_PORT="$2"
DATABASE_DATABASE="$3"
DATABASE_USERNAME="$4"
DATABASE_PASSWORD="$5"

source /database/config/db2inst1/sqllib/db2profile

db2 catalog tcpip node prvsndb2 remote "${DATABASE_HOST}" server "${DATABASE_PORT}";
db2 catalog db NAME as "${DATABASE_DATABASE}" at node prvsndb2;
db2 connect to "${DATABASE_DATABASE}" user "${DATABASE_USERNAME}" using "${DATABASE_PASSWORD}";
