kubectl kustomize\
 "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.3.0" |\
 kubectl apply -f -