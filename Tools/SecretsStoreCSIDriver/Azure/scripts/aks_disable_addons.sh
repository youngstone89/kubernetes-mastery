#!/usr/bin/env bash

az aks disable-addons --addons azure-keyvault-secrets-provider -g ps-xaas-stack-resource-group -n ps-xaas-stack-aks-cluster