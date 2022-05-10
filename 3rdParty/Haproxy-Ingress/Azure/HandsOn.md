$ helm repo add haproxytech https://haproxytech.github.io/helm-charts

```
$ helm upgrade --install kubernetes-ingress haproxytech/kubernetes-ingress \
    --set controller.ingressClass=nuance-coretech \
    --set controller.service.type=LoadBalancer
```

### Hardcode NodePort numbers
```
$ helm install haproxy haproxytech/kubernetes-ingress \
  --set controller.service.nodePorts.http=30000 \
  --set controller.service.nodePorts.https=30001 \
  --set controller.service.nodePorts.stat=30002
```

### Deploy as DaemonSet
```
$ helm install haproxy haproxytech/kubernetes-ingress \
  --set controller.kind=DaemonSet
  --set controller.daemonset.useHostPort=true
```
