#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

if ! command -v ps 1> /dev/null 2> /dev/null; then
  echo "ps command not found. Installing..."
  dnf install procps -y 1> /dev/null
fi

echo "Starting db2 process"
/var/db2_setup/lib/setup_db2_instance.sh 2>&1 > /tmp/db2.log &

count=0
while [[ "${count}" -lt 6 ]]; do
  if [[ $(pgrep -f -c db2sysc) -gt 0 ]]; then
    echo "db2sysc process started"
    break
  fi

  echo "  Waiting for db2 process to start. Sleeping for 60 seconds."
  count=$((count + 1))
  sleep 60
done

set -e

echo "DB2 is ready. Running commands..."

su - db2inst1 -c "${SCRIPT_DIR}/run_database_commands.sh '${DATABASE_HOST}' '${DATABASE_PORT}' '${DATABASE_DATABASE}' '${DATABASE_USERNAME}' '${DATABASE_PASSWORD}' '${SCHEMAS}'"
