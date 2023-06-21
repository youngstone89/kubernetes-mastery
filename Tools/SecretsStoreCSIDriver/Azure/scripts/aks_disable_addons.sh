#!/usr/bin/env bash

az aks disable-addons --addons azure-keyvault-secrets-provider -g $RESOURCE_GROUP -n $CLUSTER_NAME
