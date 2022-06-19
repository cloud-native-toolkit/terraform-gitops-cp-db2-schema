#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

dnf install procps -y

/var/db2_setup/lib/setup_db2_instance.sh &

count=0
while [[ "${count}" -lt 6 ]]; do
  if [[ $(pgrep -f -c db2sysc) -gt 0 ]]; then
    echo "db2sysc process started"
    break
  fi

  echo "Sleeping for 60 seconds"
  count=$((count + 1))
  sleep 60
done

echo "DB2 is ready. Running commands..."

set -e

su - db2inst1 -c "${SCRIPT_DIR}/run_database_commands.sh"
