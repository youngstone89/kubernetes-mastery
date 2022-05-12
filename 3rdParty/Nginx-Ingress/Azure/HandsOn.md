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


