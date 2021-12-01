
`https://artifacthub.io/packages/helm/bitnami/rabbitmq`
```
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm search repo bitnami
$ helm install my-release bitnami/rabbitmq
$ helm upgrade --install rabbitmq bitnami/rabbitmq -f charts/values.yaml -n analytics-ys
$ helm delete my-release
```