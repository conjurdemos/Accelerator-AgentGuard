#!/bin/bash
set -eou pipefail

source ../demo-vars.sh
source ../db-vars.sh

cat ./templates/secrets-create.yml.template			\
  | sed -e "s#{{NAMESPACE_ID}}#$NAMESPACE_ID#g"		\
  | sed -e "s#{{WORKLOAD_ID}}#$WORKLOAD_ID#g"		\
  > ./policy/secrets-create.yml

./$CONJUR_CLI append data ./policy/secrets-create.yml
./$CONJUR_CLI set data/$NAMESPACE_ID/env_vars                       \
        "{ \"MYSQL_USERNAME\": \"$MYSQL_USERNAME\",                 \
            \"MYSQL_PASSWORD\": \"$MYSQL_PASSWORD\",                \
            \"MYSQL_SERVER_ADDRESS\": \"$MYSQL_SERVER_ADDRESS\",    \
            \"MYSQL_SERVER_PORT\": \"$MYSQL_SERVER_PORT\",          \
            \"MYSQL_DBNAME\": \"$MYSQL_DBNAME\"                     \
        }"