#!/usr/bin/env bash

if [[ -z "${SCHEMAS}" ]]; then
  echo "No schemas provided. Exiting..."
  exit 0
fi

require_env_var() {
  local var_name="$1"

  if [[ -z "${var_name}" ]]; then
    echo "The variable name must be provided" >&2
    exit 1
  fi

  if [[ -z "${!var_name}" ]]; then
    echo "${var_name} must be provided as an environment variable" >&2
    exit 1
  fi
}

require_env_var "DATABASE_HOST"
require_env_var "DATABASE_PORT"
require_env_var "DATABASE_DATABASE"
require_env_var "DATABASE_USERNAME"
require_env_var "DATABASE_PASSWORD"

SCHEMA_FILE="/tmp/db2-schema.sql"

SCHEMA_LIST=$(echo "${SCHEMAS}" | tr ";" "\n")

echo -n "** Running as "
whoami

echo "Creating schema(s) in database: ${DATABASE_DATABASE}"

for schema in $SCHEMA_LIST; do
  echo "create schema '${schema}';" >> "${SCHEMA_FILE}"
  echo "grant dbadm on database to user '${schema}';" >> "${SCHEMA_FILE}"
done

db2 -tf "${SCHEMA_FILE}"
