#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

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

"${SCRIPT_DIR}/connect_remote_database.sh" "${DATABASE_HOST}" "${DATABASE_PORT}" "${DATABASE_DATABASE}" "${DATABASE_USERNAME}" "${DATABASE_PASSWORD}"
"${SCRIPT_DIR}/create_schemas.sh" "${SCHEMAS}"
"${SCRIPT_DIR}/run_script.sh" "${DATABASE_DATABASE}"
