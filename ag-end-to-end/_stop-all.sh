#!/bin/bash
pushd mcp-server > /dev/null 2>&1
  ./_stop-mcp-server.sh
popd > /dev/null 2>&1
if test -d conjur-oss-cloud; then
  pushd conjur-oss-cloud > /dev/null 2>&1
    ./stop-conjur
  popd > /dev/null 2>&1
fi
echo "Stopping and removing jwt-this container..."
docker stop jwt-this  > /dev/null 2>&1
docker rm jwt-this  > /dev/null 2>&1
echo "Stopping and removing mysql container..."
docker stop mysql  > /dev/null 2>&1
docker rm mysql  > /dev/null 2>&1
