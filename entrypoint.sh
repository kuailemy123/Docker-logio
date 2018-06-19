#!/bin/sh -x

set -o errexit

if [ "${LOGIO_SERVICE}" = 'harvester' ]; then
  /usr/local/bin/log.io-harvester
else
  /usr/local/bin/log.io-server
fi
