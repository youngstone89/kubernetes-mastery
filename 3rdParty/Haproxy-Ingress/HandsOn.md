# Getting Started
[Installation Link](https://haproxy-ingress.github.io/docs/getting-started/)

## Installation
```
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
```

```
helm install haproxy-ingress haproxy-ingress/haproxy-ingress\
  --create-namespace --namespace ingress-controller\
  --version 0.13.6\
  -f haproxy-ingress-values.yaml
```
## Deploy and Expose
```
$ kubectl create deployment echoserver --image k8s.gcr.io/echoserver:1.3
```
```
$ kubectl expose deployment echoserver --port=8080
```

```
$ kubectl create ingress echoserver\
  --annotation kubernetes.io/ingress.class=haproxy\
  --rule="echoserver.local/*=echoserver:8080,tls"
```