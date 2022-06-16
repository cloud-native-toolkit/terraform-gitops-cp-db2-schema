#!/usr/bin/env sh

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

if [ ! -f "${SCRIPT_DIR}/custom_script.sh" ]; then
  echo "No custom script provided. Exiting..."
  exit 0
fi

"${SCRIPT_DIR}/custom_script.sh" "${DATABASE_DATABASE}"
