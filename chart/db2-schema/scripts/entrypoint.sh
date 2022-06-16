#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

/var/db2_setup/lib/setup_db2_instance.sh &

sleep 300

"${SCRIPT_DIR}/connect_remote_database.sh" "${DATABASE_HOST}" "${DATABASE_PORT}" "${DATABASE_DATABASE}" "${DATABASE_USERNAME}" "${DATABASE_PASSWORD}"
"${SCRIPT_DIR}/create_schemas.sh"
"${SCRIPT_DIR}/run_script.sh"
