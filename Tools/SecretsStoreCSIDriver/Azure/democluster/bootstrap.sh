
# create cluster
az aks create -n ps-laa-cluster -g ps-xaas-stack-resource-group --enable-addons azure-keyvault-secrets-provider --enable-managed-identity --enable-oidc-issuer --enable-workload-identity
# "clientId": "f83a85ce-884a-4020-afaa-1ece36bfe453",

# set context
az aks get-credentials -n ps-laa-cluster -g ps-xaas-stack-resource-group

# check node pools
az aks show --resource-group ps-xaas-stack-resource-group --name ps-laa-cluster --query agentPoolProfiles

# scale down node pool to 1
az aks scale --resource-group ps-xaas-stack-resource-group --name ps-laa-cluster --node-count 1 --nodepool-name nodepool1

# verify azure key vault provider for secrets store csi driver
kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver, secrets-store-provider-azure)'


# create keyvault
export KEYVAULT_NAME=ps-laa-keyvault
az keyvault create -n ${KEYVAULT_NAME} -g ps-xaas-stack-resource-group -l eastus

# set secert
az keyvault secret set --vault-name ps-laa-keyvault -n UserName --value Youngstone

# install aks-preview extension
az extension add --name aks-preview

# enabled workload identity preview and refresh
az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
az provider register --namespace Microsoft.ContainerService


# update cluster to enable workload identity
az aks update -g ps-xaas-stack-resource-group -n ps-laa-cluster --enable-workload-identity

# configure workload identity
az account set --subscription 4ae36834-b6fb-4292-85b6-c2505f9d9f1f

# create a managed identity
az identity create --name ps-laa-identity --resource-group ps-xaas-stack-resource-group
export USER_ASSIGNED_CLIENT_ID="$(az identity show -g ps-xaas-stack-resource-group --name ps-laa-identity --query 'clientId' -o tsv)"


# set an access policy that grants the workload identity permission to access the Keyh Vault secrets
az keyvault set-policy -n ps-laa-keyvault --key-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group
az keyvault set-policy -n ps-laa-keyvault --secret-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group
az keyvault set-policy -n ps-laa-keyvault --certificate-permissions get --spn $USER_ASSIGNED_CLIENT_ID -g ps-xaas-stack-resource-group

# Key vault's Directory ID in Properties
# TODO
export IDENTITY_TENANT=$(az aks show --name ps-laa-cluster --resource-group ps-xaas-stack-resource-group --query aadProfile.tenantId -o tsv)


# update cluster to use oidc issuer
az aks update -g ps-xaas-stack-resource-group -n ps-laa-cluster --enable-oidc-issuer

# get OIDC Issuer URL
export AKS_OIDC_ISSUER="$(az aks show -n ps-laa-cluster -g ps-xaas-stack-resource-group --query "oidcIssuerProfile.issuerUrl" -otsv)"


# establish a federated identity credential between the Azure AD application
# and the service account issuer and subject
export serviceAccountName="workload-identity-sa"  # sample name; can be changed
export serviceAccountNamespace="live-agent-adapter" # can be changed to namespace of your workload

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: ${USER_ASSIGNED_CLIENT_ID}
  labels:
    azure.workload.identity/use: "true"
  name: ${serviceAccountName}
  namespace: ${serviceAccountNamespace}
EOF

# create federated identity credential between the Managed Identity
# and the service account issuer and the subject

export federatedIdentityName="aksfederatedidentity" # can be changed as needed
az identity federated-credential create --name $federatedIdentityName --identity-name ps-laa-identity --resource-group ps-xaas-stack-resource-group --issuer ${AKS_OIDC_ISSUER} --subject system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}

export federatedIdentityName="laafederatedidentity" # can be changed as needed
az identity federated-credential create \
--name laafederatedidentity \
--identity-name ps-laa-identity \
--resource-group ps-xaas-stack-resource-group \
--issuer "https://eastus.oic.prod-aks.azure.com/29208c38-8fc5-4a03-89e2-9b6e8e4b388b/f09b3de6-45dc-4120-b9ef-d8db57322d5f/" \
--subject "system:serviceaccount:live-agent-adapter:live-agent-adapter-sa"


# deploy StroageProviderClass


# deploy sample pod
kubectl apply -f pod.yaml -n $serviceAccountNamespace


# enable auto rotation
az aks addon update -g ps-xaas-stack-resource-group -n ps-laa-cluster -a azure-keyvault-secrets-provider --enable-secret-rotation