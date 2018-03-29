#!/bin/bash

set -B # enable brace expansion

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COORDINATOR_IP=$(ansible tag_druid_coordinator -m debug -a "var=inventory_hostname" | grep inventory_hostname | awk -F':' '{print $2}' | sed -e 's/"//g' | xargs)
URL="http://${COORDINATOR_IP}:8081/druid/indexer/v1/task"

curl -L -H'Content-Type: application/json' -XPOST --data-binary @${DIR}/index-benchmark-data.json $URL
