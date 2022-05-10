$ helm repo add haproxytech https://haproxytech.github.io/helm-charts

$ helm install kubernetes-ingress haproxytech/kubernetes-ingress \
    --create-namespace \
    --namespace haproxy-controller \
    --set controller.service.type=LoadBalancer