#!/bin/bash -e
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

## Dirty hack to fix mysql-client module
patch /root/.nami/components/com.bitnami.mysql-client/main.js < /mysql.patch

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  nami_initialize mysql-client trinitycore 
fi

exec tini -- "$@"
