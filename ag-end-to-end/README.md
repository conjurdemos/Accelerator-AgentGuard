# Agent Guard End-to-End

A fully realized demonstration of an agentic workflow that does not require any licenses or subscriptions:

- JWT authentication (no API key) to secrets manager (Conjur OSS)
- MCP server retrieves secrets from Conjur
- Secrets are kept ephemeral with Agent Guard
- MCP server shields secrets from LLM (no secret leakage)
- Ollama LLM agent for querying a simple 3-table MySQL DB using natural language prompts.

## Dependencies

- MacOS or Ubuntu >22.04
- Python >= 3.10
- uv or poetry package manager
- jq, wget & git CLIs

## Structure

- **start-demo.sh:**<br>
Assumes above dependencies are met. Installs, configures and runs all components below. It first runs _stop-all.sh which is destructive.
- **_stop-all.sh:**<br>
Stops all running demo processes and removes stopped containers.
- **demo-vars.sh:**<br>
This is the master configuration file.
- **db-vars.sh:**<br>
This is the master configuration file for the MySQL database.
- **JWT provider:** [jwt-this](https://github.com/tr1ck3r/jwt-this)<br>
jwt-this is a standalone NON-PRODUCTION issuer of JWTs with support for user-configurable claims. It is started by start-demo.sh and runs as a Docker container.
- **Secrets Manager:**<br>
The start-demo.sh script will clone the repo
[conjur-oss-cloud](https://github.com/jodyhuntatx/conjur-oss-cloud) and run its  shell scripts to configure Conjur OSS policy structure like CyberArk Secrets Manager - SaaS (Conjur Cloud). This makes it easy to port the demo to a CyberArk tenant by simply changing variables in demo-vars. Conjur OSS runs as collection of Docker containers managed with Docker Compose.
    - **Configuration:**<br>
    The directory conjur-admin contains scripts and policy templates to configure authn-jwt, create an agent host identity and DB secrets.
- **MCP Server:**<br>
A custom MCP server implemented with FastMCP that supports a single tool: run_sql_query. It runs as a Python process.
    - **Configuration:**<br>
    The start-demo.sh script uses scripts and executables in the  *mcp-server* directory to run the MCP server. The server uses a bespoke version of Agent Guard (agent_guard_core) to work around runtime error stemming from self-signed certificates in Conjur OSS.
- **Database:**<br>
MySQL 8.2 running as a Docker container.
    - **Configuration:**<br>
    The start-demo.sh script uses scripts in the *mysql-admin* directory to configure the MySQL DB schema and load test data.
- **AI Agent:**<br>
Ollama running llama3.2:1b (default). 
    - **Configuration:**<br>
    The start-demo.sh script will use scripts in the *ollama-agent* directory to install ollama and mcphost resources and run the agent.
- **_clean.sh:**<br>
Removes all files and directories created by demo to clean directory tree before checking into source control.

## Execution Flow

1) check that assumed dependencies are met.
2) Run: start-demo.sh
3) Query the database.<br>
Suggestions:
    - "list all pets in the db."
    - "list all owners in the db."
    - "Who owns the pet Lilah?"
4) Try stopping the Ollama agent and running it with a more capable (larger) LLM like gpt-oss:20b.