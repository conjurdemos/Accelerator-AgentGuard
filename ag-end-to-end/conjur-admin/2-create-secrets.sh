#!/bin/bash
set -eou pipefail

source ../demo-vars.sh
source ../db-vars.sh

cat ./templates/secrets-create.yml.template			\
  | sed -e "s#{{IDENTITY_PATH}}#$IDENTITY_PATH#g"		\
  > ./policy/secrets-create.yml

./$CONJUR_CLI append data ./policy/secrets-create.yml
./$CONJUR_CLI set data/$IDENTITY_PATH/env_vars                       \
        "{ \"MYSQL_USERNAME\": \"$MYSQL_USERNAME\",                 \
            \"MYSQL_PASSWORD\": \"$MYSQL_PASSWORD\",                \
            \"MYSQL_SERVER_ADDRESS\": \"$MYSQL_SERVER_ADDRESS\",    \
            \"MYSQL_SERVER_PORT\": \"$MYSQL_SERVER_PORT\",          \
            \"MYSQL_DBNAME\": \"$MYSQL_DBNAME\"                     \
        }"