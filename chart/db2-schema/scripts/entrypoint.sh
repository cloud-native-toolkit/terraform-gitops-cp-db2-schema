#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

#!/bin/sh
/var/db2_setup/lib/setup_db2_instance.sh &

${SCRIPT_DIR}/create_schemas.sh
${SCRIPT_DIR}/run_script.sh
