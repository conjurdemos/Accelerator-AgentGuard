export DOCKER="docker"
export DOCKER_CLI_HINTS=false

# jwt-this JWKS endpoint
export JWT_INT_PORT=8000
export JWT_EXT_PORT=8001
export JWKS_EXT_URI=http://localhost:${JWT_EXT_PORT}/.well-known/jwks.json

# Conjur OSS config
export CONJUR_CLI=coss-cli.sh
export HTTP_VERIFY=False
export CONJUR_APPLIANCE_URL=https://localhost:8443
export CONJUR_ACCOUNT=conjur
export CONJUR_ADMIN_USER=admin
export CONJUR_ADMIN_PASSWORD=CyberArk11@@

# Conjur JWT authn values
export AUTHN_JWT_ID=agentic
export IDENTITY_PATH=data/$AUTHN_JWT_ID         # Conjur policy path to host identity definition
export TOKEN_APP_PROPERTY=workload              # claim containing name of host identity
export WORKLOAD_ID=ai-agent
export JWT_ISSUER=http://localhost:${JWT_EXT_PORT}
export JWT_AUDIENCE=conjur

# MCP port to listen on
export MCP_HTTP_PORT=8040

# Non-secret values used by Agent Guard
export CONJUR_AUTHENTICATOR_ID="authn-jwt/$AUTHN_JWT_ID"
export CONJUR_AUTHN_LOGIN=$WORKLOAD_ID
export NAMESPACE_ID="$IDENTITY_PATH/env_vars"
