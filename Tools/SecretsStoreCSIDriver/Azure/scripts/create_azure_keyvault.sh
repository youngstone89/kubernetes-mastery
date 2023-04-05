az keyvault create -n ps-xaas-keyvault -g ps-xaas-stack-resource-group -l eastus
az keyvault secret set --vault-name ps-xaas-keyvault -n ExampleSecret --value MyAKSExampleSecret