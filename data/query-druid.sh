#!/bin/bash

set -B # enable brace expansion

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BROKER_IP=$(ansible tag_druid_broker -m debug -a "var=inventory_hostname" | grep inventory_hostname | awk -F':' '{print $2}' | sed -e 's/"//g' | xargs)
URL="http://${BROKER_IP}:8082/druid/v2/?pretty"
for i in {1..100000}; do
    HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -L -H'Content-Type: application/json' -XPOST --data-binary @${DIR}/topN.json $URL)
    # extract the status
	HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    # extract the body
    HTTP_BODY=$(echo $HTTP_RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
    if test $HTTP_STATUS -ne 200 || test "${HTTP_BODY}" == "[ ]"; then
        echo "BOOM!! status:$HTTP_STATUS, response: $HTTP_BODY"
    fi

    n=$((i%100))
    if test $n -eq 0; then
        echo "Step $i"
    fi
done


