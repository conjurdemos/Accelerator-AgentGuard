#!/bin/bash
./_stop-all.sh
rm -rf mcp-server/.venv mcp-server/*.lock mcp-server/*.log
rm -rf conjur-oss-cloud conjur-admin/policy/*
