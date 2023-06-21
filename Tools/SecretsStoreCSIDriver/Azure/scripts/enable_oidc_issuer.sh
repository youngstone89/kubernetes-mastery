#!/usr/bin/env bash
az aks update -g $RESOURCE_GROUP -n $CLUSTER_NAME --enable-oidc-issuer
