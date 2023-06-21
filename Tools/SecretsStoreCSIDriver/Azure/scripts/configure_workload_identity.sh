#!/usr/bin/env bash

export subscriptionID=$SUBSCRIPTION_ID
export resourceGroupName=$RESOURCE_GROUP
export UAMI=sscsid-identity
export KEYVAULT_NAME="<PLACE_HOLDER>"
export clusterName="<PLACE_HOLDER>"

az account set --subscription $SUBSCRIPTION_ID

# create a managed identity
az identity create --name sscsid-identity --resource-group $RESOURCE_GROUP
export USER_ASSIGNED_CLIENT_ID="$(az identity show -g $RESOURCE_GROUP --name sscsid-identity --query 'clientId' -o tsv)"
export IDENTITY_TENANT=$(az aks show --name ps-xaas-stack-cluster --resource-group $RESOURCE_GROUP --query aadProfile.tenantId -o tsv)

# set an access policy that grants the workload identity permission to access the Keyh Vault secrets
az keyvault set-policy -n $KEYVAULT_NAME --key-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g $RESOURCE_GROUP
az keyvault set-policy -n $KEYVAULT_NAME --secret-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g $RESOURCE_GROUP
az keyvault set-policy -n $KEYVAULT_NAME --certificate-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g $RESOURCE_GROUP
