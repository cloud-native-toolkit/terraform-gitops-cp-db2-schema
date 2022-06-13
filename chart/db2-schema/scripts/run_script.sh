#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

if [[ ! -f "${SCRIPT_DIR}/custom_script.sh" ]]; then
  echo "No custom script provided. Exiting..."
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

SCHEMA_FILE="/tmp/schema.db2"

cat > "${SCHEMA_FILE}" << EOM
db2 catalog tcpip node prvsndb2 remote "'"${DATABASE_HOST}"'" server "'"${DATABASE_PORT}"'";
db2 catalog db NAME as "'"${DATABASE_DATABASE}"'" at node prvsndb2;
db2 connect to "'"${DATABASE_DATABASE}"'" user "'"${DATABASE_USERNAME}"'" using "'"${DATABASE_PASSWORD}"'";
EOM

"${SCRIPT_DIR}/custom_script.sh"
