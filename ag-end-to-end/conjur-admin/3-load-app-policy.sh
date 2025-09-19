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

cat ./templates/app-secrets-grant.yml.template		\
  | sed -e "s#{{AUTHN_JWT_ID}}#$AUTHN_JWT_ID#g"		\
  | sed -e "s#{{NAMESPACE_ID}}#$NAMESPACE_ID#g"			\
  > ./policy/app-secrets-grant.yml

./$CONJUR_CLI append data ./policy/app-secrets-grant.yml
