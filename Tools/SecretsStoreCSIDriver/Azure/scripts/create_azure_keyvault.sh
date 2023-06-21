az keyvault create -n ps-xaas-keyvault -g $RESOURCE_GROUP -l eastus
az keyvault secret set --vault-name ps-xaas-keyvault -n ExampleSecret --value MyAKSExampleSecret
