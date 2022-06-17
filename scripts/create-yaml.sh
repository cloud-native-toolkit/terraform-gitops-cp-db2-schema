#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)
CHART_DIR=$(cd "${MODULE_DIR}/chart/db2-schema"; pwd -P)

if [[ ! -d "${CHART_DIR}" ]]; then
  echo "Chart dir not found: ${CHART_DIR}" >&2
  exit 1
fi

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

NAME="$1"
DEST_DIR="$2"

mkdir -p "${DEST_DIR}"

## Add logic here to put the yaml resource content in DEST_DIR
cp -R "${CHART_DIR}/"* "${DEST_DIR}"

if [[ -n "${VALUES_CONTENT}" ]]; then
  echo "${VALUES_CONTENT}" | \
    yq4 eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "${CHART_DIR}/values.yaml" - \
    > "${DEST_DIR}/values.yaml"
fi



