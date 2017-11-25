#!/bin/bash

set -euo pipefail

beat=$1
#es_url=http://elastic:${ELASTIC_PASSWORD}@elasticsearch:9200

until ${beat} setup -E setup.kibana.host=kibana
do
    sleep 2
    echo Retrying...
done

