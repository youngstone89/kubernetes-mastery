https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip?tabs=azure-cli



# Install Nginx Ingress Controller
```
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace nuance-asraas  \
    --set controller.ingressClassResource.name=nginx-asraas \
    --set controller.ingressClassResource.controllerValue="nginx-asraas" \
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
helm install nginx-asraas ingress-nginx/ingress-nginx \
--namespace nuance-asraas \
--set controller.ingressClassResource.name="nginx-asraas"
--set controller.ingressClass="nginx-asraas" \
--set controller.replicaCount=2 \
--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="nginx-asraas"

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
### Generate TLS certificates
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out aks-ingress-tls.crt \
    -keyout aks-ingress-tls.key \
    -subj "/CN=demo.azure.com/O=aks-ingress-tls"
```
### Create Kubernetes secret for the TLS certificate
```
kubectl create secret tls aks-ingress-tls \
    --namespace nginx-ingress-test \
    --key aks-ingress-tls.key \
    --cert aks-ingress-tls.crt
```

```
kubectl apply -f tls-ingress.yaml --namespace nginx-ingress-test
```

### Test the ingress configuration 
```
curl -v -k --resolve demo.azure.com:443:20.102.13.247 https://demo.azure.com
curl -v -k --resolve demo.azure.com:443:20.102.13.247 https://demo.azure.com/hello-world-two
```

### Configure an FQDN for the ingress controller
#### Method 1: Set the DNS label using the Azure CLI
```
# Public IP address of your ingress controller
IP="MY_EXTERNAL_IP"

# Name to associate with public IP address
DNSNAME="demo-aks-ingress"

# Get the resource-id of the public ip
PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

# Update public ip address with DNS name
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

# Display the FQDN
az network public-ip show --ids $PUBLICIPID --query "[dnsSettings.fqdn]" --output tsv
```
#### Method 2: Set the DNS label using helm chart settings
```
DNS_LABEL="nginx-asraas"
helm upgrade nginx-asraas ingress-nginx/ingress-nginx \
  --namespace nuance-asraas \
  --set controller.ingressClassResource.name="nginx-asraas" \
  --set controller.ingressClass="nginx-asraas" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=$DNS_LABEL

```
```
grpc-test.eastus.cloudapp.azure.com.
```
```
nginx-asraas.eastus.cloudapp.azure.com.
```

### Install cert-manager
```
# Label the namespace to disable resource validation
kubectl label namespace nuance-asraas cert-manager.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace nuance-asraas \
  --set installCRDs=false \
  --set nodeSelector."kubernetes\.io/os"=linux 
```
### Create a CA cluster issuer
Before certificates can be issued, cert-manager requires an Issuer or ClusterIssuer resource. These Kubernetes resources are identical in functionality, however Issuer works in a single namespace, and ClusterIssuer works across all namespaces. For more information, see the cert-manager issuer documentation.
```
kubectl apply -f cert-manager-tls-ingress.yaml --namespace nuance-asraas
```
### Verify a certificate object has been created
```
$ kubectl get certificate --namespace nginx-ingress-test
```
```
$ kubectl get certificate --namespace nuance-asraas
```