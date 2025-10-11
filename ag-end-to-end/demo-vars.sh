export DOCKER="docker"
export DOCKER_CLI_HINTS=false

# jwt-this JWKS endpoint
export JWT_INT_PORT=8000
export JWT_EXT_PORT=8001
export JWKS_EXT_URI=http://localhost:${JWT_EXT_PORT}/.well-known/jwks.json

export CONJUR=oss
if [ "$CONJUR" = "cloud" ]; then
    # Identity oauth2 service account w/ Secrets Manager - Conjur Cloud Admin role
    export CYBERARK_ADMIN_USER=newjodybot@cyberark.cloud.3357
    # Service account password
    export CYBERARK_ADMIN_PWD=$(keyring get cybrid jodybotpwd)
    # "Friendly" tenant name (i.e. not like aab1234)
    export CYBERARK_TENANT_SUBDOMAIN=cybr-secrets

    # Do not change the 6 vars below
    export CYBERARK_IDENTITY_URL=https://${CYBERARK_TENANT_SUBDOMAIN}.cyberark.cloud/api/idadmin
    export CYBERARK_CCLOUD_API=https://${CYBERARK_TENANT_SUBDOMAIN}.secretsmgr.cyberark.cloud/api
    export CONJUR_APPLIANCE_URL=$CYBERARK_CCLOUD_API
    export CONJUR_ACCOUNT="conjur"
    export CONJUR_CLI=ccloud-cli.sh
    export HTTP_VERIFY=True
else
    # Conjur OSS configuration
    export CONJUR_ADMIN_USER="admin"
    export CONJUR_ADMIN_PASSWORD="CyberArk11@@"
    export CONJUR_APPLIANCE_URL="https://localhost:8443"
    export CONJUR_ACCOUNT="conjur"
    export CONJUR_CLI=coss-cli.sh
    export HTTP_VERIFY=False   
fi

# Conjur JWT authn values
export AUTHN_JWT_ID=agentic
export IDENTITY_PATH=$AUTHN_JWT_ID         # Conjur policy path to host identity definition
export TOKEN_APP_PROPERTY=workload              # claim containing name of host identity
export WORKLOAD_ID=ai-agent
export JWT_ISSUER=http://localhost:${JWT_EXT_PORT}
export JWT_AUDIENCE=conjur

# MCP port to listen on
export MCP_HTTP_PORT=8040

# Non-secret values used by Agent Guard
export CONJUR_AUTHENTICATOR_ID="authn-jwt/$AUTHN_JWT_ID"
export CONJUR_AUTHN_LOGIN="data/$IDENTITY_PATH/$WORKLOAD_ID"
export NAMESPACE_ID="data/$IDENTITY_PATH/env_vars"
