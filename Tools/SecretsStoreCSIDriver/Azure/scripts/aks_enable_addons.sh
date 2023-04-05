
# install
az aks enable-addons --addons azure-keyvault-secrets-provider --name ps-xaas-stack-aks-cluster --resource-group ps-xaas-stack-resource-group

# verify
kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver, secrets-store-provider-azure)'
