#!/bin/bash

source ../demo-vars.sh
# Notice that no db-vars are included here.
# Those values are retrieved from Conjur by Agent Guard

./_stop-mcp-server.sh

echo "Updating Python dependencies..."
if [[ "$(which uv)" ]]; then
  uv sync
  PKGMGR=uv
elif [[ "$(which poetry)" ]]; then
  poetry update
  PKGMGR=poetry
fi

echo "Starting MCP server in background..."
rm -f mcp-mysql.log

# get JWT from jwt-this to use to authenticate to Conjur
export CONJUR_AUTHN_JWT=$(curl -s -d "$TOKEN_APP_PROPERTY=$WORKLOAD_ID" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -X POST http://localhost:$JWT_EXT_PORT/token | jq -r .access_token)

# Demo uses a modified version of agent_guard_core to work around
# self-signed cert issues in Conjur OSS.
export PYTHONPATH=./agent_guard_core
nohup $PKGMGR run python3 mcp-mysql.py > mcp-mysql.log 2>&1 &
echo "Waiting for server to startup..."
sleep 15
cat mcp-mysql.log
