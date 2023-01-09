#!/usr/bin/env bash



export subscriptionID=4ae36834-b6fb-4292-85b6-c2505f9d9f1f
export resourceGroupName=ps-xaas-stack-resource-group
export UAMI=sscsid-identity
export KEYVAULT_NAME=ps-xaas-keyvault
export clusterName=ps-xaas-stack-cluster

az account set --subscription 4ae36834-b6fb-4292-85b6-c2505f9d9f1f

# create a managed identity
az identity create --name sscsid-identity --resource-group ps-xaas-stack-resource-group
export USER_ASSIGNED_CLIENT_ID="$(az identity show -g ps-xaas-stack-resource-group --name sscsid-identity --query 'clientId' -o tsv)"
export IDENTITY_TENANT=$(az aks show --name ps-xaas-stack-cluster --resource-group ps-xaas-stack-resource-group --query aadProfile.tenantId -o tsv)

# set an access policy that grants the workload identity permission to access the Keyh Vault secrets
az keyvault set-policy -n ps-xaas-keyvault --key-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group
az keyvault set-policy -n ps-xaas-keyvault --secret-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group
az keyvault set-policy -n ps-xaas-keyvault --certificate-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group