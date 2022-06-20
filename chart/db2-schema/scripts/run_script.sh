#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DATABASE_DATABASE="$1"
DATABASE_USERNAME="$2"
DATABASE_PASSWORD="$3"

if [[ ! -f "${SCRIPT_DIR}/custom_script.sh" ]]; then
  echo "No custom script provided. Exiting..."
  exit 0
fi

set -e

echo -n "** Running as "
whoami

echo "Logging into database ${DATABASE_DATABASE} as user ${DATABASE_USERNAME}"

db2 connect to "${DATABASE_DATABASE}" user "${DATABASE_USERNAME}" using "${DATABASE_PASSWORD}";

echo "Executing custom script in database: ${DATABASE_DATABASE}"

"${SCRIPT_DIR}/custom_script.sh" "${DATABASE_DATABASE}"
