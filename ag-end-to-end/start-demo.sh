#!/bin/bash

source ./demo-vars.sh
source ./db-vars.sh

main() {
  ./install-dependencies.sh
  ./_stop-all.sh
  start_jwt_this
  start_mysql
  start_conjur
  start_mcp_server
  start_ollama
}

start_jwt_this() {
  echo; echo
  echo "Starting jwt-this (JWT issuer) container..."
  docker run -d                                   \
    --name jwt-this                               \
    -p $JWT_EXT_PORT:8000                         \
    tr1ck3r/jwt-this:latest                       \
    -u ${JWT_ISSUER} -a ${JWT_AUDIENCE} -t RSA
}

start_mysql() {
  echo; echo
  echo "Starting MySQL server container..."
  docker run -d                                     \
    --name mysql                                    \
    -p $MYSQL_SERVER_PORT:3306                      \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD     \
    -e MYSQL_DATABASE=$MYSQL_DATABASE               \
    -e MYSQL_USER=$MYSQL_USER                       \
    -e MYSQL_PASSWORD=$MYSQL_PASSWORD               \
    mysql:8.2.0
  pushd mysql-admin > /dev/null 2>&1
    ./init_mysql.sh
  popd > /dev/null 2>&1
}

start_conjur() {
  if [[ $CONJUR == "oss" ]]; then
    start_conjur_oss
  fi
  pushd conjur-admin > /dev/null 2>&1
    ./1-config-jwt-authn.sh
    ./2-create-secrets.sh
    ./3-load-app-policy.sh
  popd > /dev/null 2>&1
}

start_conjur_oss() {
  echo; echo
  echo "Starting Conjur OSS server containers..."
  # conjur-oss-cloud configures a Conjur OSS instance with the 
  # same structure as CyberArk Secrets Manager - SaaS (AKA Conjur Cloud)
  # This demo could be easily migrated to work with Conjur Cloud.
  if ! test -d conjur-oss-cloud; then
    git clone git@github.com:jodyhuntatx/conjur-oss-cloud.git
  fi
  if ! test -d conjur-oss-cloud; then
    echo; echo
    echo "Clone of conjur-oss-cloud failed. Check git configuration."
    echo; echo
    exit -1
  fi
  pushd conjur-oss-cloud > /dev/null 2>&1
    ./start-conjur
    ./test_retrieval.sh
  popd   > /dev/null 2>&1
}

start_mcp_server() {
  echo; echo
  echo "Starting MCP server container..."
  pushd mcp-server > /dev/null 2>&1
    ./start-mcp-server.sh
  popd > /dev/null 2>&1
}

start_ollama() {
  echo; echo
  echo "Starting Ollama LLM client..."
  pushd ollama-agent > /dev/null 2>&1
    ./0-setup.sh
    ./1-run-ollama.sh
  popd > /dev/null 2>&1
}

main "$@"
