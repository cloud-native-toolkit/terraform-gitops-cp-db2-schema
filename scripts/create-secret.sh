#!/usr/bin/env bash

NAMESPACE="$1"
DEST_DIR="$2"

export PATH="${BIN_DIR}:${PATH}"

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

if [[ -z "${DB_USER_PASSWORD}" ]] ; then
  echo " DB_USER_PASSWORD must be provided as environment variables"
  exit 1
fi

kubectl create secret generic db2inst1-user-credentials \
  --from-literal="db2inst1_password=${DB_USER_PASSWORD}" \
  -n "${NAMESPACE}" \
  --dry-run=client \
  --output=yaml > "${DEST_DIR}/db2inst1-user-credentials.yaml"

