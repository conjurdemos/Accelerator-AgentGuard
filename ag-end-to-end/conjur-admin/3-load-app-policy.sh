#!/bin/bash
set -eou pipefail

source ../demo-vars.sh

cat ./templates/app-authn-jwt.yml.template			\
  | sed -e "s#{{AUTHN_JWT_ID}}#$AUTHN_JWT_ID#g"		\
  | sed -e "s#{{WORKLOAD_ID}}#$WORKLOAD_ID#g"			\
  | sed -e "s#{{TOKEN_APP_PROPERTY}}#$TOKEN_APP_PROPERTY#g"	\
  > ./policy/app-authn-jwt.yml

./$CONJUR_CLI append data ./policy/app-authn-jwt.yml

cat ./templates/app-authn-grant.yml.template		\
  | sed -e "s#{{AUTHN_JWT_ID}}#$AUTHN_JWT_ID#g"		\
  > ./policy/app-authn-grant.yml

./$CONJUR_CLI append conjur/authn-jwt ./policy/app-authn-grant.yml
 
# In this demo, secrets are part of the identity policy and
# access is granted there. If secrets are defined in a separate policy
# (e.g. created by the vault synchronizer), a separate access grant is needed.
<<COMMENT
cat ./templates/app-secrets-grant.yml.template		\
  | sed -e "s#{{AUTHN_JWT_ID}}#$AUTHN_JWT_ID#g"		\
  | sed -e "s#{{IDENTITY_PATH}}#$IDENTITY_PATH#g"			\
  > ./policy/app-secrets-grant.yml

./$CONJUR_CLI append data ./policy/app-secrets-grant.yml
COMMENT
