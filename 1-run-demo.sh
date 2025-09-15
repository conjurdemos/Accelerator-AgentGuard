#!/usr/bin/env bash

if [ ! -d "./agent-guard" ]; then
  git clone git@github.com:cyberark/agent-guard.git
fi

if [[ "$(which uv)" ]]; then
  uv sync
  PKGMGR=uv
elif [[ "$(which poetry)" ]]; then
  poetry update
  PKGMGR=poetry
fi

export PYTHONPATH="./agent-guard"
$PKGMGR run python3 filevars.py
