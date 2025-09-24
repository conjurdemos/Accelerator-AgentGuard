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

- **start-demo.sh:** Master startup script that assumes above dependencies are met. Installs, configures and runs all components below. It first runs _stop-all.sh **which is destructive**.
- **_stop-all.sh:** Script that stops all running demo processes and removes stopped demo containers.
- **demo-vars.sh:** This is the master configuration file which sets environment variables used across all demo components.
- **db-vars.sh:** This is the master configuration file for the MySQL database.
- **JWT provider:** [jwt-this](https://github.com/tr1ck3r/jwt-this) is a standalone NON-PRODUCTION issuer of JWTs with support for user-configurable claims. It is started by *start-demo.sh* and runs as a Docker container.
- **Secrets Manager:** [conjur-oss-cloud](https://github.com/jodyhuntatx/conjur-oss-cloud) is a repo that installs [Conjur OSS](https://www.conjur.org/) and configures its policy structure to match that of CyberArk Secrets Manager - SaaS (Conjur Cloud). This makes it easy to port this demo to a CyberArk tenant by simply changing variables in *demo-vars.sh*. Conjur OSS runs as collection of Docker containers managed with Docker Compose.
    - **Configuration:**<br>
    The *start-demo.sh* script uses scripts and policy templates in the *conjur-admin* directory to configure authn-jwt, create an agent host identity and DB secrets.
- **MCP Server:** A custom MCP server implemented with FastMCP that supports a single tool: run_sql_query. It runs as a Python process.
    - **Configuration:**<br>
    The *start-demo.sh* script uses scripts and executables in the  *mcp-server* directory to manage the MCP server. The server uses a bespoke version of Agent Guard (agent_guard_core) to work around runtime issues stemming from self-signed certificates in Conjur OSS.
- **Database:** MySQL 8.2 running as a Docker container.
    - **Configuration:**<br>
    The *start-demo.sh* script uses scripts in the *mysql-admin* directory to configure the MySQL DB schema and load test data.
- **AI Agent:** Ollama running llama3.2:1b (default). 
    - **Configuration:**<br>
    The *start-demo.sh* script will use scripts in the *ollama-agent* directory to install ollama and mcphost resources and run the agent. The *1-start-ollama.sh* script in that directory takes a command line argument to specify an ollama model to use. By default it runs with llama3.2:1b.
- **_clean.sh:** Removes all files and directories created by demo to clean directory tree before checking into source control.

## Execution Flow

1) check that assumed dependencies are met.
2) Run: start-demo.sh
3) Query the database.<br>
Suggestions:
    - "list all pets in the db."
    - "list all owners in the db."
    - "Who owns the pet Lilah?"
4) Try stopping the Ollama agent (ctrl-C) and running it with a more capable (larger) LLM like gpt-oss:20b.
    - cd ollama-agent
    - ./1-run-ollama.sh gpt-oss:20b
    gpt-oss is a model tuned for tool use and can handle much more complex queries than llama3.1:1b.