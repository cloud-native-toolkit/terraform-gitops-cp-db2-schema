#!/usr/bin/env bash

NAMESPACE="$1"
SECRET_NAME="$2"
DEST_DIR="$3"

export PATH="${BIN_DIR}:${PATH}"

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  exit 1
fi

mkdir -p "${DEST_DIR}"

if [[ -z "${DATABASE_USERNAME}" ]] || [[ -z "${DATABASE_PASSWORD}" ]] || [[ -z "${DATABASE_HOST}" ]] || [[ -z "${DATABASE_PORT}" ]] || [[ -z "${DATBASE_NAME}" ]]; then
  echo "DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_HOST, DATABASE_PORT, and DATABASE_NAME are required as environment variables"
  exit 1
fi

kubectl create secret generic "${SECRET_NAME}" \
  --from-literal="host=${DATABASE_HOST}" \
  --from-literal="port=${DATABASE_PORT}" \
  --from-literal="database=${DATABASE_NAME}" \
  --from-literal="username=${DATABASE_USERNAME}" \
  --from-literal="password=${DATABASE_PASSWORD}" \
  -n "${NAMESPACE}" \
  --dry-run=client \
  --output=yaml > "${DEST_DIR}/secret.yaml"
