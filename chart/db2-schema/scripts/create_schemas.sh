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

SCHEMA_FILE="/tmp/schema.db2"

cat > "${SCHEMA_FILE}" << EOM
db2 catalog tcpip node prvsndb2 remote "'"${DATABASE_HOST}"'" server "'"${DATABASE_PORT}"'";
db2 catalog db NAME as "'"${DATABASE_DATABASE}"'" at node prvsndb2;
db2 connect to "'"${DATABASE_DATABASE}"'" user "'"${DATABASE_USERNAME}"'" using "'"${DATABASE_PASSWORD}"'";
EOM

SCHEMA_LIST=$(echo "${SCHEMAS}" | tr ";" "\n")

for schema in $SCHEMA_LIST; do
  useradd -NM -d / -f -1 -s /sbin/nologin -K UID_MIN=2000 "${schema}" && echo "${schema}:${schema}" | chpasswd "${schema}"

  echo "db2 create schema ${schema};" >> "${SCHEMA_FILE}"
  echo "db2 grant dbadm on database to user ${schema};" >> "${SCHEMA_FILE}"
done
