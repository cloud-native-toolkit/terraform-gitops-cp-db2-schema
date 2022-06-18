#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

/var/db2_setup/lib/setup_db2_instance.sh &

count=0
while [ "${count}" -lt 4 ]; do
  echo "Sleeping for 60 seconds"
  count=$((count + 1))
  sleep 60
done

echo "Done sleeping"

set -e

su - db2inst1 -c "${SCRIPT_DIR}/connect_remote_database.sh '${DATABASE_HOST}' '${DATABASE_PORT}' '${DATABASE_DATABASE}' '${DATABASE_USERNAME}' '${DATABASE_PASSWORD}'"
su - db2inst1 -c "${SCRIPT_DIR}/create_schemas.sh"
su - db2inst1 -c "${SCRIPT_DIR}/run_script.sh"
