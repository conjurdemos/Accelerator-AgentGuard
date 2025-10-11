#!/bin/bash
./_stop-all.sh
for d in $(find . -type d | grep __pycache__); do rm -rf $d; done
rm -rf mcp-server/.venv mcp-server/*.lock mcp-server/*.log
rm -rf conjur-oss-cloud conjur-admin/policy/*
