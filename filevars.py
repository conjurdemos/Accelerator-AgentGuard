#!/usr/bin/python3

import os, asyncio

#----------------------------------------
# Get secrets from File as env vars
from agent_guard_core.credentials import FileSecretsProvider, EnvironmentVariablesManager

@EnvironmentVariablesManager.set_env_vars(FileSecretsProvider())
async def myFunc() -> None:
  username = os.getenv("USERNAME")
  password = os.getenv("PASSWORD")
  print(f"Username: {username}, Password: {password}")

if __name__ == '__main__':
  if not os.getenv("USERNAME"):
    print("Username not found")

  asyncio.run(myFunc())

  if not os.getenv("PASSWORD"):
    print("Password not found")