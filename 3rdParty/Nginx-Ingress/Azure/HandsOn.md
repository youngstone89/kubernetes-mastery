https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip?tabs=azure-cli



# Install Nginx Ingress Controller
```
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic --create-namespace \
    --set controller.ingressClassResource.name=nginx-basic \
    --set controller.ingressClassResource.controllerValue="example.com/ingress-nginx-basic" \
    --set controller.ingressClassResource.enabled=true \
    --set controller.ingressClassByName=true
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux 
```

# Create an ingress controller in Azure Kubernetes Service (AKS)
https://docs.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli

There are two open source ingress controllers for Kubernetes based on Nginx: One is maintained by the Kubernetes community (kubernetes/ingress-nginx), and one is maintained by NGINX, Inc. (nginxinc/kubernetes-ingress). This article will be using the Kubernetes community ingress controller.

## Pre requisites
* Azure CLI 2.0.64 or later
* AKS cluster integrated with ACR


### Configure ACR integration for existing AKS clusters
```
# set this to the name of your Azure Container Registry.  It must be globally unique
az aks update -n ps-xaas-stack-aks-cluster -g ps-xaas-stack-resource-group --attach-acr psXaasStackAcr
```

### Basic configuration
```


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

NAMESPACE=ingress-basic
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

```

### Customized configuration
https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx?modal=values&path=controller.ingressClassResource.name
```
helm install nginx-ingress-test ingress-nginx/ingress-nginx \
--create-namespace \
--namespace nginx-ingress-test \
--set controller.ingressClassResource.name="nginx-ingress-test"
--set controller.ingressClass="nginx-ingress-test" \
--set controller.replicaCount=2 \
--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="grpc-test"

```
https://docs.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli

### Run demo applications
```
kubectl apply -f aks-helloworld-one.yaml --namespace nginx-ingress-test
kubectl apply -f aks-helloworld-two.yaml --namespace nginx-ingress-test

```

### Create an ingress route
```
kubectl apply -f ingress.yaml --namespace nginx-ingress-test
```
