az aks addon update -g $RESOURCE_GROUP -n $CLUSTER -a azure-keyvault-secrets-provider --enable-secret-rotation --rotation-poll-interval 1m
