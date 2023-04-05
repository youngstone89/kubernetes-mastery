#!/usr/bin/env bash
export AKS_OIDC_ISSUER="$(az aks show --resource-group ps-xaas-stack-resource-group --name ps-xaas-stack-aks-cluster --query "oidcIssuerProfile.issuerUrl" -o tsv)"
echo $AKS_OIDC_ISSUER